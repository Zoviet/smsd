local template = require('resty.template')
local sentitems = require('db.sentitems')

local limit = 200
local offset = 0
local req = ngx.req.get_uri_args() 
if req.limit then limit = tonumber(req.limit) end
if req.offset then offset = tonumber(req.offset) end

local view = template.new("sent.html", "layout.html")
view.title = "Not Sent"
view.count = tonumber(sentitems.countNotSent())
view.messages = sentitems.getNotSent(limit,offset)
view:render()
