express = require 'express'
http = require 'http'
app = express()
server = http.createServer(app)
io = require('socket.io')(server)
util = require "util"
mime = require "mime"
fs = require "fs"
multipart = require 'connect-multiparty'
multipartMiddleware = multipart()
app.use express.static('public')

app.post '/images', multipartMiddleware, (req, res) ->
  tmpPath = req.files.image.path
  fs.readFile tmpPath, (err, buf) ->
    if err?
      res.status(422)
      return
    data = buf.toString('base64')
    io.sockets.emit 'push image', {dataUrl: util.format("data:%s;base64,%s", mime.lookup(tmpPath), data) }
    res.end()

server.listen(8080)
