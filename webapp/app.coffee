ClientTemplates = require 'client-templates'
browserify      = require 'roots-browserify'
autoprefixer = require('autoprefixer-stylus')

module.exports =
  ignores: ['.divshot-cache', 'readme.md'],
  stylus:
    use: [autoprefixer()]

  extensions: [
    ClientTemplates(
      base: "views/templates/",
      pattern: "**/*.jade",
      out: "js/templates.js"
    ),


    browserify(
      files: "assets/js/main.coffee"
      out: 'js/main.js'
      transforms: [
        'coffeeify'
        'debowerify'
      ]
    )
  ]
