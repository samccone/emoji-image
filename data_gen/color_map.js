var d = require('./foo.json')
var fs = require('fs')
var _ = require('lodash')
var arr = [];
var bArr = [];

for(var i = 0; i < 32; ++i) {
  for(var j = 0; j < 32; ++j) {
    for(var k = 0; k < 32; ++k) {
      arr[i] = arr[i] || [];
      arr[i][j] = arr[i][j] || [];
      arr[i][j][k] = null;

      bArr[i] = bArr[i] || [];
      bArr[i][j] = bArr[i][j] || [];
      bArr[i][j][k] = null;
    }
  }
}


function getIndex(v, wiggle) {
  wiggle = wiggle || 0;

  wiggle *= ~~(Math.random()*2) ? -1 : 1;

  return [
    ~~(Math.min(31, Math.max(v.rgba[0] / 8 + Math.random()*wiggle, 0))),
    ~~(Math.min(31, Math.max(v.rgba[1] / 8 + Math.random()*wiggle, 0))),
    ~~(Math.min(31, Math.max(v.rgba[2] / 8 + Math.random()*wiggle, 0)))
  ]
}

d.forEach(function(v) {
  var i = getIndex(v);

  var lookup = v.sheet_x+","+v.sheet_y;
  if (arr[i[0]][i[1]][i[2]]) {
    i = getIndex(v, 2);

    arr[i[0]][i[1]][i[2]] = lookup
  } else {
    arr[i[0]][i[1]][i[2]] = lookup
  }
})


function isEmpty(i, j, k) {
  return arr[i][j][k] == null;
}

function writeNeighbors(i, j, k) {
  bArr[i][j][k] = arr[i][j][k];
  if (i+1 < 32 && isEmpty(i+1, j, k)) {
    bArr[i+1][j][k] = arr[i][j][k];
  }

  if (i-1 >= 0 && isEmpty(i-1, j, k)) {
    bArr[i-1][j][k] = arr[i][j][k];
  }

  if (j+1 < 32 && isEmpty(i, j+1, k)) {
    bArr[i][j+1][k] = arr[i][j][k];
  }

  if (j-1 >= 0 && isEmpty(i, j-1, k)) {
    bArr[i][j-1][k] = arr[i][j][k];
  }

  if (k+1 < 32 && isEmpty(i, j, k+1)) {
    bArr[i][j][k+1] = arr[i][j][k];
  }

  if (k-1 >= 0 && isEmpty(i, j, k-1)) {
    bArr[i][j][k-1] = arr[i][j][k];
  }
}

for(var z = 0; z< 32; ++z) {
  for(var i = 0; i < 32; ++i) {
    for(var j = 0; j < 32; ++j) {
      for(var k = 0; k < 32; ++k) {
        if (!isEmpty(i,j,k)) {
          writeNeighbors(i, j, k);
        }
      }
    }
  }

  arr = _.cloneDeep(bArr);
}

fs.writeFileSync('color_hard_map.js', "var goats ="+JSON.stringify(bArr, null)+";");
