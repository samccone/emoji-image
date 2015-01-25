ClientTemplates = require 'client-templates'
browserify      = require 'roots-browserify'

module.exports =
 extensions: [
    ClientTemplates(
      base: "views/templates/",
      pattern: "**/*.jade",
      out: "js/templates.js"
    )

    browserify(
      files: "assets/js/main.coffee"
      out: 'js/main.js'
      transforms: [
        'coffeeify'
        'debowerify'
      ]
    )
  ]