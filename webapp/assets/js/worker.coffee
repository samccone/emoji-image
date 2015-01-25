window.requestAnimFrame = (->
  return  window.requestAnimationFrame       or
          window.webkitRequestAnimationFrame or
          window.mozRequestAnimationFrame    or
          ->
            window.setTimeout(callback, 1000 / 60);
)()

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

      process(20, ctx, img)
      # process(5, ct2, img)
      # process(20, ctx2, img)

    img.src = url

processVideo = (video) ->
  ctx.drawImage(video, 0,0)
  process(20, ctx, video);
  requestAnimationFrame processVideo.bind(this, video);

module.exports =
  process: run
  processVideo: processVideo
