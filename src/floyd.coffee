define [], () ->
  getIndex = ({imageData, x, y}) ->
    index = (x + y * imageData.width) * 4


  getPixel = ({imageData, x, y}) =>
    index = getIndex {imageData, x, y}
    color =
      r: imageData.data[index+0]
      g: imageData.data[index+1]
      b: imageData.data[index+2]
      a: imageData.data[index+3]


  setPixel = ({imageData, x, y, color}) =>
    index = getIndex {imageData, x, y}
    {r, g, b, a} = color

    imageData.data[index+0] = r
    imageData.data[index+1] = g
    imageData.data[index+2] = b
    imageData.data[index+3] = a


  PixelsFor = (imageData) =>
    Pixels = (x, y) =>
      get: () =>
        getPixel {imageData, x, y}
      set: (color) =>
        setPixel {imageData, x, y, color}

  randomNoise = (imageData) ->
    i = 0
    while i < 10000
      x = Math.random() * width | 0 # |0 to truncate to Int32
      y = Math.random() * height | 0
      r = Math.random() * 256 | 0
      g = Math.random() * 256 | 0
      b = Math.random() * 256 | 0
      setPixel({imageData, x, y, r, g, b, a: 255})
      i++
    return imageData


  loadImage = (ctx, src, onload=null) ->
    image = new Image()
    image.src = src
    image.onload = () ->
      ctx.canvas.width = image.width
      ctx.canvas.height = image.height
      ctx.drawImage image, 0, 0
      onload() if onload?


  quantizeColor = (color, bits) ->
    depth = Math.pow 2, bits

    # keys == [r, g, b, a]
    error = {}
    quantized = {}
    for c in ['r', 'g', 'b', 'a']
      ratio = Math.floor (color[c] / 255 * depth)
      step = 255 / depth
      qc = ratio * step
      e = Math.abs (qc - color[c])
      error[c] = e
      quantized[c] = qc

    return {error, quantized}


  diffuseError = (color, weight, error) ->
    diffused = {}

    for c in ['r', 'g', 'b', 'a']
      diffused[c] = Math.floor (color[c] + weight*error[c])

    return diffused


  quantizePixel = (Pixels, x, y, bits) ->
    color = Pixels(x, y).get()
    {error, quantized} = quantizeColor color, bits
    Pixels(x, y).set quantized


  k = 1/16 # diffusion constant
  ditherPixel = (Pixels, x, y, bits) ->
    color = Pixels(x, y).get()
    {error, quantized} = quantizeColor color, bits
    Pixels(x, y).set quantized

    offsets = [
      x: 1
      y: 0
      weight: 7*k
     ,
      x: -1
      y: 1
      weight: 3*k
     ,
      x: 0
      y: 1
      weight: 5*k
     ,
      x: 1
      y: 1
      weight: 1*k
    ]

    for o in offsets
      diffused = diffuseError Pixels(x+o.x, y+o.y).get(), o.weight, error
      Pixels(x+o.x, y+o.y).set diffused


  process = (imageData, bits, processPixel) ->
    Pixels = PixelsFor imageData
    {width, height} = imageData

    # for x in [0..width-1]
    #   for y in [0..height-1]
    #     processPixel Pixels, x, y, bits

    for y in [0..height-1]
      for x in [0..width-1]
        processPixel Pixels, x, y, bits

    return imageData


  quantize = (imageData, bits) ->
    process imageData, bits, quantizePixel


  dither = (imageData, bits) ->
    process imageData, bits, ditherPixel


  animatedDither = (ctx, bits, delay) ->
    {width, height} = ctx.canvas


    nextDither = (x, y) ->
      return if (x is width) and (y is height)
      ctx = ctx.canvas.getContext '2d'

      dataWindow = ctx.getImageData x, y, 3, 2
      ditherPixel (PixelsFor dataWindow), 0, 0, bits
      ctx.putImageData dataWindow, x, y

      nextX = (x + 1) % width
      nextY = if nextX is 0 then y + 1 else y

      next = () -> nextDither nextX, nextY
      setTimeout next, delay

    nextDither 0, 0


  exports = {
    animatedDither
    dither
    ditherPixel
    quantize
    quantizePixel
    loadImage
    process
  }

  return exports
