express = require "express"
path = require "path"
multer = require "multer"
path = require "path"
app = express()
bodyParser = require 'body-parser'
config = require "./config"

app.use express.static(path.join(__dirname, 'public'))
#app.use multer({dest: "./public/uploads"})
#app.use bodyParser.json()
#app.use bodyParser.urlencoded()
#app.use busboy {immediate: true}

# Upload handler
app.post "/images", multer
  dest: "./public/uploads"
  onFileUploadStart: (file, req, res)->
    DONT_SAVE = no
    if not isImage(file.name)
      res.status(200).json {result: "Not a image file!"}
      return DONT_SAVE
    else 
      return true
  onFileUploadComplete: (file, req, res)->
    res.json 
      result: "OK"
      path: "#{config.HOST}/uploads/#{file.name}"

isImage = (fileName)->
  ext = (path.extname fileName).toLowerCase()
  return ext in ['.jpg', '.png', '.gif']

app.listen(8080)