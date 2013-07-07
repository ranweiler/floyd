resetCanvas = () ->
  canvas = document.getElementById 'whiteboard'
  canvas.width += 1
  canvas.width -= 1
  # ctx = canvas.getContext '2d'
  # c
  # console.log {ctx}
  # ctx.clearRect 0, 0, canvas.width, canvas.height

drawInterval = (ctx, y) -> ([a, b]) ->
  ctx.beginPath()
  ctx.moveTo a, y
  ctx.lineTo b, y
  ctx.closePath()
  ctx.stroke()

cantorize = (interval) ->
  [a, b] = interval
  size = Math.abs (b-a)
  return [
    [a, a+size*(1/3)]
    [b-size*(1/3), b]
  ]

nextCantor = (xs) ->
  xs = xs.map(cantorize).reduce (x, y) -> x.concat y
  return xs

cantorTo = (n) ->
  xs = [[0, 1]]
  return xs if n < 1
  
  for i in [1..n]
    xs = nextCantor xs
  return xs

drawCantor = (k) ->
  canvas = document.getElementById 'whiteboard'
  ctx = canvas.getContext '2d'
  ctx.fillStyle = 'rgb(0,0,0)'
  ctx.lineWidth = 1.0
  ctx.scale canvas.width, canvas.height/(k*2)
  ctx.translate 0, ctx.lineWidth/2
  
  for i in [0..k-1]
    xs = cantorTo i
    xs.map (drawInterval ctx, 0+2*i)

genCantorize = (pattern) ->
  (interval) ->
    [a, b] = interval
    size = Math.abs (b-a)
    divisions = pattern.length
    c = size/divisions
    result = (([a+i*c, a+(i+1)*c] if x) for x, i in pattern).filter (x) -> x?
    return result

nextGenCantor = (pattern) ->
  (xs) ->
    xs = xs.map(genCantorize pattern).reduce (x, y) -> x.concat y
    return xs

genCantorTo = (pattern, n) ->
  xs = [[0, 1]]
  return xs if n < 1

  _nextGC = nextGenCantor pattern

  for i in [1..n]
    xs = _nextGC xs
  return xs

drawGenCantor = (pattern, k) ->
  # resetCanvas()
  canvas = document.getElementById 'whiteboard'
  ctx = canvas.getContext '2d'
  ctx.fillStyle = 'rgb(0,0,0)'
  ctx.lineWidth = 1.0
  ctx.scale canvas.width, canvas.height/(k*2)
  ctx.translate 0, ctx.lineWidth/2
  
  for i in [0..k-1]
    xs = genCantorTo pattern, i
    xs.map (drawInterval ctx, 0+2*i)
                        
$().ready () ->
  drawGenCantor [1,0,1], 8
  $('#redraw').click () ->
    console.log 'redrawing'
    resetCanvas()
    pattern = eval $('#pattern').val()
    depth = eval $('#depth').val()
    drawGenCantor pattern, depth
