# Thy Word

## Dependencies

### System

The below dependencies are required:

* PostgreSQL
* Redis
* Ruby 3.4.1

### Application

To install Ruby dependencies run:

```console
$ bundle install
```

## Configuration

### Environment Variables

For local `development` sensible defaults have been used. You shouldn't need to
do anything. For non-development environments such `production` you should only
need to set:

* `NODE_ENV`
* `RAILS_ENV`
* `RAILS_MASTER_KEY`

### Secrets

Environment specific credentials are stored in encrypted `.yml.enc` files in the
`config/credentials/` folder (matching the name of the environment). Rails uses
`config/master.key`, `config/credentials/<environment>.key` or alternatively
looks for the environment variable `ENV["RAILS_MASTER_KEY"]` to encrypt the
credentials file.

```console
$ bundle exec rails credentials:edit --environment <environment>
```

Because the credentials file is encrypted, it can be stored in version control,
as long as the respective master key is kept safe. See `rails credentials:help`
for more details.

## Database

### Creation & Initialization

Assuming you have a root user (with no password) ... first create the tables in
the database by running `rails db:create`. This will create 2 databases:

* `thy_word_development` - used when running the app in development mode (ideal
  for testing locally).
* `thy_word_test` - used by the app when running the test suites.

Then run the migrations by running `rails db:schema:load db:migrate` to create
the database structure i.e. columns, indices in the table for you. You may also
drop the databases using `rails db:drop` or reset via `rails db:reset` (which
will seed as well). Each of these actions will respect the environment set via
`RAILS_ENV=test` (as an example).

## Testing

### Code Style

Use the `rubocop` command to check for code style violations:

```console
# Check all Ruby source files in the current directory
$ bundle exec rubocop

# Alternatively pass rubocop a list of files and directories to check
$ bundle exec rubocop app/ spec/ lib/something.rb
```

## Running

### Local: Development

```console
$ bundle exec rails server
```

### Remote: Production

```console
$ export NODE_ENV=production \
         RAILS_ENV=production \
         RAILS_MASTER_KEY=<environment-key>

$ bundle exec rails server
```
