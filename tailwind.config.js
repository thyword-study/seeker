/** @type {import('tailwindcss').Config} */
export default {
    content: [
        "./public/*.html",
        "./app/assets/stylesheets/**/*.css",
        "./app/helpers/**/*.rb",
        "./app/javascript/**/*.js",
        "./app/views/**/*.html.erb"
    ],
    theme: {
        extend: {},
    },
    plugins: [],
};
