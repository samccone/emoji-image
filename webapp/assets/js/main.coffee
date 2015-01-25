worker = require("./worker")

getMedia = require("../../bower_components/getUserMedia/index-browser")
$ = require("../../bower_components/jquery/dist/jquery.min.js")
video = document.createElement('video')
video.setAttribute('width', '600px')
video.setAttribute('height', '400px')

objUrl = if window.webkitURL then webkitURL else URL

$('.picker .static').on "click", ->
  $this = $(this)

  return if ($this.hasClass('active'))

  $('.active').removeClass('active')
  $this.addClass('active')


  worker.stopVideo(video)
  d = JSON.parse($(this).attr('config'))

  $('.pipeline input[type="range"]').each (i, v) ->
    $(v).val(d[i])

  worker.process(
    $this.css('background-image').match(/url\((.*)\)/)[1]
  )

$('input[type="file"]').on "change", ->
  if (!this.files[0].name.match(/\.png|\.jpg|\.jpeg/))
    alert("This only works with jpg or png sorry :(")
    return


  if (!objUrl?)
    alert("Local file API is not enabled on your browser. Try Chrome, or Safari")
    return

  url = objUrl.createObjectURL(this.files[0])

  $('.active').removeClass('active')

  worker.process(url)

$('.video').on "click", ->
  $('.active').removeClass('active')

  getMedia {audio:false,video:true}, (err, stream) ->
    if (err)
      return alert("unable to init video stream, try in chrome!")

    $('.pipeline input[type="range"]').each (i, v) ->
      $v = $(v)

      if parseInt($v.val(), 10) < 10 && parseInt($v.val() , 10) > 0
        $v.val(15)

    video.src = objUrl.createObjectURL(stream)
    video.play()
    setTimeout (-> worker.processVideo(video)), 60

$('.download').on "click", ->
  window.open($('canvas').eq(1)[0].toDataURL())
