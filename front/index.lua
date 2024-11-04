local template = require('resty.template')
local phones = require('db.phones')

local view = template.new("index.html", "layout.html")
view.title  = "Active Phones and Modems"
view.phones =  phones.info()
view:render()

