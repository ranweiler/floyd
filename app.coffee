connect = require 'connect'

app = connect()
app.use (connect.logger 'dev')
app.use (connect.static 'public')
app.use (req, res) -> res.end 'hello, world\n'

app.listen 3000