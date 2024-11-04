local template = require('resty.template')
local phones = require('db.phones')
local outbox = require('db.outbox')

local view = template.new("send.html", "layout.html")
view.title = "Send SMS"
view.count = tonumber(phones.count())
view.phones = phones.getIds()
ngx.req.read_body()	
local args, err = ngx.req.get_post_args()
if args.submit then
	if not(args.TextDecoded == '') or not(args.DestinationNumber == '') then 
		args.Coding = 'Unicode_Compression'
		args.CreatorID = 'SMShub'
		args.submit = nil
		res = outbox.add(args)
		if res then view.message = 'Success!' end
	else
		view.message = 'No message text or destination number'
	end
end
view:render()
