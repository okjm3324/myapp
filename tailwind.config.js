module.exports = {


  plugins: [require("daisyui")],
  daisyui: { 
    themes: ["forest"],
  },
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ]
}
