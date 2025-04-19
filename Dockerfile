FROM ruby:3.4.3-bookworm

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential

# NodeJS
ARG NODE_MAJOR_VERSION="23"
ARG NODE_PKG_VERSION="23.11.0-1nodesource1"
RUN curl --proto '=https' --tlsv1.2 -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - && \
    apt-get install -qq -y nodejs=${NODE_PKG_VERSION} && \
    rm -rf /var/lib/apt/lists/*

# Postgres
RUN echo "deb http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg && \
    apt-get update -qq -y && \
    apt-get -qq -y install libpq-dev postgresql-client-17

# Yarn
ARG YARN_VERSION="1.22.22-1"
RUN wget -q -O- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb https://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq -y && \
    apt-get install --no-install-recommends -qq -y yarn=${YARN_VERSION} && \
    rm -rf /var/lib/apt/lists/*

# ARGs & ENVs
ARG APP_USER="app"
ENV BUNDLE_PATH="/srv/bundle" \
    HOME="/home/${APP_USER}" \
    NODE_ENV="production" \
    RAILS_ENV="production"
ARG CODE_PATH="/srv/code"

# User
RUN groupadd -g 1000 ${APP_USER} && \
    useradd --system --create-home -u 1000 -g 1000 ${APP_USER} && \
    mkdir -p ${BUNDLE_PATH} ${CODE_PATH}

# Set the working directory
WORKDIR ${CODE_PATH}

# Cache & install javascript dependencies
COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn install --frozen-lockfile && \
    yarn config set production true && \
    yarn cache clean && \
    rm -rf ${HOME}/{.cache,.config}

# Cache, install & cleanup ruby gem dependencies
COPY Gemfile Gemfile.lock ./
RUN export BUNDLER_VERSION=$(cat Gemfile.lock | tail -1 | tr -d "[:space:]") && \
    gem install bundler -v "${BUNDLER_VERSION}" && \
    bundle config set frozen "true" && \
    bundle config set without "test development hotfix" && \
    bundle install && \
    bundle exec bootsnap precompile --gemfile && \
    rm -rf ${BUNDLE_PATH}/{cache,ruby/*/cache}

# Copy the rest of the app
ADD . ${CODE_PATH}

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets
RUN bundle exec rails assets:precompile --trace

# Fix permissions
RUN chown -R ${APP_USER}:${APP_USER} \
    db/schema.rb \
    log/ \
    tmp/

ARG GIT_RELEASE
ENV GIT_RELEASE="${GIT_RELEASE:-unset}"

# Run as app
USER ${APP_USER}:${APP_USER}
