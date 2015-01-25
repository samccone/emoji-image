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

      process(5, ctx, img)
      # process(5, ct2, img)
      # process(20, ctx2, img)

    img.src = url

module.exports =
  process: run
      # var ctx;
      # var sprite, spriteCtx;

      # //- function snip() {
      # //-   ctx.drawImage(vid, 0,0)
      # //-   process(200, ctx2);
      # //-   //- process(50, ctx2);
      # //-   //- process(25, ctx);
      # //-   //- process(20, ctx);
      # //-   //- process(8, ctx2);
      # //-   requestAnimationFrame(snip);
      # //- }

      # var sprite = new Image()
      #   process(10, ctx);
      #   //- process(40, ctx2);
      #   //- process(40, ctx2);
      #   //- process(40, ctx2);
      #   //- process(40, ctx1);
      #   //- process(40, ctx1);
      #   //- process(40, ctx1);
      #   //- process(40, ctx1);
      #   //- process(40, ctx1);
      #   //- process(40, ctx1);
      #   //- process(10, ctx);
      #   //- process(15, ctx);
      #   //- process(3, ctx);
      # }


      # //- navigator.webkitGetUserMedia({video: true, audio: false}, function(stream){
      # //-   vid = document.querySelector("video");
      # //-   vid.src = window.URL.createObjectURL(stream);
      # //-   vid.play()
      # //-   requestAnimationFrame(snip)
      # //- }, function(){})

