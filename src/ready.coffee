define ['jquery', 'app/floyd'], ($, floyd) ->
  {
    animatedDither
    dither
    loadImage
    quantize
  } = floyd

  inputCanvas = $('#input')[0]
  outputCanvas = $('#output')[0]

  inputCtx = inputCanvas.getContext '2d'
  outputCtx = outputCanvas.getContext '2d'

  if location.hash
    s = location.hash.slice(1)
    src = "img/#{s}"
  else
    src = 'img/cooldog.jpg'

  $('#process').click () ->
    {width, height} = inputCtx.canvas
    imageData = inputCtx.getImageData 0, 0, width, height
    bits = Number $('#bitSlider').val()

    putImageData = (imageData) ->
      outputCtx.canvas.width = inputCtx.canvas.width
      outputCtx.canvas.height = inputCtx.canvas.height
      outputCtx.putImageData imageData, 0, 0

    method = $('#method').val()
    switch method
      when 'Quantize'
        imageData = quantize imageData, bits
        putImageData imageData
      when 'Dither'
        imageData = dither imageData, bits
        putImageData imageData
      when 'AnimatedDither'
        delay = Number $('#delaySlider').val()
        putImageData imageData
        animatedDither outputCtx, bits, delay

  loadImage inputCtx, src

  $('#bitSlider').change () ->
    $('#bits').html ((Number @.value) * 3)

  $('#delaySlider').change () ->
    $('#delay').html (Number @.value)
