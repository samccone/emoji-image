ClientTemplates = require 'client-templates'
browserify      = require 'roots-browserify'
autoprefixer = require('autoprefixer-stylus')
rupture = require('rupture')

module.exports =
  ignores: ['.divshot-cache', 'readme.md'],
  stylus:
    use: [autoprefixer(), rupture()]

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
