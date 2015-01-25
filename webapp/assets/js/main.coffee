worker = require("./worker")

$ = require("../../bower_components/jquery/dist/jquery.min.js")

$('.picker li').on "click", ->
  $this = $(this)

  return if ($this.hasClass('active'))

  $('.active').removeClass('active')
  $this.addClass('active')

  worker.process(
    $this.css('background-image').match(/url\((.*)\)/)[1]
  )
