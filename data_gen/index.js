fs = require('fs')
gm = require('gm')
set = require('./set')
Promise = require('bluebird')
getPixels = require("get-pixels")

Promise.resolve(set)
.map(function(v, i) {
  console.log("processing --- "+i);
  return new Promise(function(res, rej) {
    gm('base.png')
    .crop(64, 64, v.sheet_x*64, v.sheet_y*64)
    .toBuffer('PNG',function (err, buffer) {
      if(err) {
        rej(err)
      }

      getPixels(buffer, "image/png", function(err, pxls) {
        if(err) {
          rej(err)
        }

        var rgb = [0,0,0,0]

        for(var i = 0; i < pxls.shape[0]; ++i) {
          for(var j = 0; j < pxls.shape[1]; ++j) {
            if (pxls.get(i, j, 3) < 127) {
              rgb[3]++
            }
            else {
              for(var k = 0; k < pxls.shape[2]-1; ++k) {
                rgb[k] += pxls.get(i, j, k);
              }
            }
          }
        }

        if (rgb[3] != 4096) {
          rgb[0] = rgb[0]/(4096-rgb[3]);
          rgb[1] = rgb[1]/(4096-rgb[3]);
          rgb[2] = rgb[2]/(4096-rgb[3]);
        }

        v.rgba = rgb;
        res(v);
      });
    })
  });
}, {concurrency: 100})
.then(function(set) {
  fs.writeFileSync("foo.json", JSON.stringify(set, null ,4));
})
