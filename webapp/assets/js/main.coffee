worker = require("./worker")

$ = require("../../bower_components/jquery/dist/jquery.min.js")

$('.picker .static').on "click", ->
  $this = $(this)

  return if ($this.hasClass('active'))

  $('.active').removeClass('active')
  $this.addClass('active')

  worker.process(
    $this.css('background-image').match(/url\((.*)\)/)[1]
  )

$('input').on "change", ->
  if (!this.files[0].name.match(/\.png|\.jpg|\.jpeg/))
    alert("This only works with jpg or png sorry :(")
    return

  klass = if window.webkitURL then webkitURL else URL

  if (!klass?)
    alert("Local file API is not enabled on your browser. Try Chrome, or Safari")
    return

  url = klass.createObjectURL(this.files[0])

  worker.process(url)
