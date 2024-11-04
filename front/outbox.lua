local template = require('resty.template')
local outbox = require('db.outbox')

local limit = 200
local offset = 0
local req = ngx.req.get_uri_args() 
if req.limit then limit = tonumber(req.limit) end
if req.offset then offset = tonumber(req.offset) end

local view = template.new("outbox.html", "layout.html")
view.title = "Queue"
view.count = tonumber(outbox.count())
view.messages = outbox.get(limit,offset)
view:render()
