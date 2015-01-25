$ = require("../../bower_components/jquery/dist/jquery.min.js")
videoLoop = null

do ->
  w = window
  for vendor in ['ms', 'moz', 'webkit', 'o']
      break if w.requestAnimationFrame
      w.requestAnimationFrame = w["#{vendor}RequestAnimationFrame"]
      w.cancelAnimationFrame = (w["#{vendor}CancelAnimationFrame"] or
                                w["#{vendor}CancelRequestAnimationFrame"])

  targetTime = 0
  w.requestAnimationFrame or= (callback) ->
      targetTime = Math.max targetTime + 16, currentTime = +new Date
      w.setTimeout (-> callback +new Date), targetTime - currentTime

  w.cancelAnimationFrame or= (id) -> clearTimeout id

sprite     = new Image()
sprite.src = "/images/base.png"
ctx = ctx2 = spriteCtx = null;

sprite.onload = ->
  spriteCanvas = document.createElement('canvas')
  spriteCanvas.setAttribute('width', sprite.width+'px')
  spriteCanvas.setAttribute('height', sprite.height+'px')
  spriteCtx = spriteCanvas.getContext('2d');
  spriteCtx.drawImage(sprite, 0, 0);

  run('/images/night.jpg')

getIndex = (x,y,width,d) ->
  index = (x + y * width) * 4;
  return [
    ~~(Math.min(31, Math.max(d[index] / 8, 0))),
    ~~(Math.min(31, Math.max(d[index+1] / 8, 0))),
    ~~(Math.min(31, Math.max(d[index+2] / 8, 0)))
  ]

runPipeline = (src) ->
  $('.pipeline input').off("change")
  $('.pipeline input').on "change", -> runSampler(src)
  runSampler(src)

clearDrawCanvas = ->
  $canvas2 = $(document.getElementsByTagName('canvas')[1])
  window.requestAnimationFrame ->
    ctx2.clearRect(0, 0, parseInt($canvas2.attr('width'), 10), parseInt($canvas2.attr('height'), 10))

runSampler = (src) ->
  if ($('.clear-between').is(":checked"))
    clearDrawCanvas()

  $('.pipeline li').each (i, v) ->
    window.requestAnimationFrame ->
      $v = $(v)
      sampleRate = parseInt($v.find('.sample').val(), 10)
      ctxSampler = if $v.find('.over-sample').is(":checked") then ctx2 else ctx

      if sampleRate > 0
        process(sampleRate, ctxSampler, src)

process = (size, context, img) ->
  size = size || 8;

  a = context.getImageData(0,0,img.width, img.height);

  x = 0
  while x < img.width
    y = 0

    while y < img.height
      index = getIndex(x, y, img.width, a.data)
      coords = (goats[index[0]][index[1]][index[2]]).split(",")
      ctx2.drawImage(
        sprite,
        coords[0] * 64,
        coords[1] * 64,
        64,
        64,
        x - size / 2,
        y - size / 2,
        size, size
      )

      y += size
    x += size

run = (url) ->
    img = new Image()

    img.onload = ->
      canvas = document.getElementsByTagName('canvas')[0]
      canvas.setAttribute('width', img.width+'px')
      canvas.setAttribute('height', img.height+'px')
      canvas2 = document.getElementsByTagName('canvas')[1]
      canvas2.setAttribute('width', img.width+'px')
      canvas2.setAttribute('height', img.height+'px')
      ctx = canvas.getContext('2d')
      ctx2 = canvas2.getContext('2d')

      ctx.drawImage(img, 0, 0)

      runPipeline(img)

    img.src = url

startProcessVideo = (video) ->
  canvas = document.getElementsByTagName('canvas')[0]
  canvas.setAttribute('width', '600px')
  canvas.setAttribute('height', '400px')
  canvas2 = document.getElementsByTagName('canvas')[1]
  canvas2.setAttribute('width', '600px')
  canvas2.setAttribute('height', '400px')

  clearDrawCanvas()
  processVideo(video)

processVideo = (video) ->
  try
    ctx.drawImage(video, 0,0)
    runPipeline(video)
    videoLoop = requestAnimationFrame(processVideo.bind(this, video))
  catch
    setTimeout (-> processVideo(video)), 100

stopVideo = (video) ->
  video.pause()
  window.cancelAnimationFrame(videoLoop)

module.exports =
  process: run
  processVideo: startProcessVideo
  stopVideo: stopVideo
