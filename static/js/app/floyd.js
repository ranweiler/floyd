// Generated by CoffeeScript 1.6.3
define([], function() {
  var PixelsFor, animatedDither, diffuseError, dither, ditherPixel, exports, getIndex, getPixel, k, loadImage, process, quantize, quantizeColor, quantizePixel, randomNoise, setPixel,
    _this = this;
  getIndex = function(_arg) {
    var imageData, index, x, y;
    imageData = _arg.imageData, x = _arg.x, y = _arg.y;
    return index = (x + y * imageData.width) * 4;
  };
  getPixel = function(_arg) {
    var color, imageData, index, x, y;
    imageData = _arg.imageData, x = _arg.x, y = _arg.y;
    index = getIndex({
      imageData: imageData,
      x: x,
      y: y
    });
    return color = {
      r: imageData.data[index + 0],
      g: imageData.data[index + 1],
      b: imageData.data[index + 2],
      a: imageData.data[index + 3]
    };
  };
  setPixel = function(_arg) {
    var a, b, color, g, imageData, index, r, x, y;
    imageData = _arg.imageData, x = _arg.x, y = _arg.y, color = _arg.color;
    index = getIndex({
      imageData: imageData,
      x: x,
      y: y
    });
    r = color.r, g = color.g, b = color.b, a = color.a;
    imageData.data[index + 0] = r;
    imageData.data[index + 1] = g;
    imageData.data[index + 2] = b;
    return imageData.data[index + 3] = a;
  };
  PixelsFor = function(imageData) {
    var Pixels;
    return Pixels = function(x, y) {
      return {
        get: function() {
          return getPixel({
            imageData: imageData,
            x: x,
            y: y
          });
        },
        set: function(color) {
          return setPixel({
            imageData: imageData,
            x: x,
            y: y,
            color: color
          });
        }
      };
    };
  };
  randomNoise = function(imageData) {
    var b, g, i, r, x, y;
    i = 0;
    while (i < 10000) {
      x = Math.random() * width | 0;
      y = Math.random() * height | 0;
      r = Math.random() * 256 | 0;
      g = Math.random() * 256 | 0;
      b = Math.random() * 256 | 0;
      setPixel({
        imageData: imageData,
        x: x,
        y: y,
        r: r,
        g: g,
        b: b,
        a: 255
      });
      i++;
    }
    return imageData;
  };
  loadImage = function(ctx, src, onload) {
    var image;
    if (onload == null) {
      onload = null;
    }
    image = new Image();
    image.src = src;
    return image.onload = function() {
      ctx.canvas.width = image.width;
      ctx.canvas.height = image.height;
      ctx.drawImage(image, 0, 0);
      if (onload != null) {
        return onload();
      }
    };
  };
  quantizeColor = function(color, bits) {
    var c, depth, e, error, qc, quantized, ratio, step, _i, _len, _ref;
    depth = Math.pow(2, bits);
    error = {};
    quantized = {};
    _ref = ['r', 'g', 'b', 'a'];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      c = _ref[_i];
      ratio = Math.floor(color[c] / 255 * depth);
      step = 255 / depth;
      qc = ratio * step;
      e = Math.abs(qc - color[c]);
      error[c] = e;
      quantized[c] = qc;
    }
    return {
      error: error,
      quantized: quantized
    };
  };
  diffuseError = function(color, weight, error) {
    var c, diffused, _i, _len, _ref;
    diffused = {};
    _ref = ['r', 'g', 'b', 'a'];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      c = _ref[_i];
      diffused[c] = Math.floor(color[c] + weight * error[c]);
    }
    return diffused;
  };
  quantizePixel = function(Pixels, x, y, bits) {
    var color, error, quantized, _ref;
    color = Pixels(x, y).get();
    _ref = quantizeColor(color, bits), error = _ref.error, quantized = _ref.quantized;
    return Pixels(x, y).set(quantized);
  };
  k = 1 / 16;
  ditherPixel = function(Pixels, x, y, bits) {
    var color, diffused, error, o, offsets, quantized, _i, _len, _ref, _results;
    color = Pixels(x, y).get();
    _ref = quantizeColor(color, bits), error = _ref.error, quantized = _ref.quantized;
    Pixels(x, y).set(quantized);
    offsets = [
      {
        x: 1,
        y: 0,
        weight: 7 * k
      }, {
        x: -1,
        y: 1,
        weight: 3 * k
      }, {
        x: 0,
        y: 1,
        weight: 5 * k
      }, {
        x: 1,
        y: 1,
        weight: 1 * k
      }
    ];
    _results = [];
    for (_i = 0, _len = offsets.length; _i < _len; _i++) {
      o = offsets[_i];
      diffused = diffuseError(Pixels(x + o.x, y + o.y).get(), o.weight, error);
      _results.push(Pixels(x + o.x, y + o.y).set(diffused));
    }
    return _results;
  };
  process = function(imageData, bits, processPixel) {
    var Pixels, height, width, x, y, _i, _j, _ref, _ref1;
    Pixels = PixelsFor(imageData);
    width = imageData.width, height = imageData.height;
    for (y = _i = 0, _ref = height - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; y = 0 <= _ref ? ++_i : --_i) {
      for (x = _j = 0, _ref1 = width - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
        processPixel(Pixels, x, y, bits);
      }
    }
    return imageData;
  };
  quantize = function(imageData, bits) {
    return process(imageData, bits, quantizePixel);
  };
  dither = function(imageData, bits) {
    return process(imageData, bits, ditherPixel);
  };
  animatedDither = function(ctx, bits, delay) {
    var height, nextDither, width, _ref;
    _ref = ctx.canvas, width = _ref.width, height = _ref.height;
    nextDither = function(x, y) {
      var dataWindow, next, nextX, nextY;
      if ((x === width) && (y === height)) {
        return;
      }
      ctx = ctx.canvas.getContext('2d');
      dataWindow = ctx.getImageData(x, y, 3, 2);
      ditherPixel(PixelsFor(dataWindow), 0, 0, bits);
      ctx.putImageData(dataWindow, x, y);
      nextX = (x + 1) % width;
      nextY = nextX === 0 ? y + 1 : y;
      next = function() {
        return nextDither(nextX, nextY);
      };
      return setTimeout(next, delay);
    };
    return nextDither(0, 0);
  };
  exports = {
    animatedDither: animatedDither,
    dither: dither,
    ditherPixel: ditherPixel,
    quantize: quantize,
    quantizePixel: quantizePixel,
    loadImage: loadImage,
    process: process
  };
  return exports;
});
