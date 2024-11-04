local template = require('resty.template')
local phones = require('db.phones')

local limit = 200
local offset = 0
local req = ngx.req.get_uri_args() 
if req.limit then limit = tonumber(req.limit) end
if req.offset then offset = tonumber(req.offset) end

local view = template.new("phones.html", "layout.html")
view.title = "Phones/Modems"
view.count = tonumber(phones.count())
view.phones = phones.get(limit,offset)
view:render()
