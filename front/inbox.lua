local template = require('resty.template')
local inbox = require('db.inbox')

local limit = 200
local offset = 0
local req = ngx.req.get_uri_args() 
if req.limit then limit = tonumber(req.limit) end
if req.offset then offset = tonumber(req.offset) end

local view = template.new("inbox.html", "layout.html")
view.title = "Inbox"
view.count = tonumber(inbox.count())
view.messages = inbox.get(limit,offset)
view:render()
