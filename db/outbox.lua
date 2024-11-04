local _M = {}
local db = require('db.mysql')

function _M.get(limit,offset)
	local cur 
	if offset == nil then offset = 0 end
	if offset == nil then limit = 200 end
	cur = db.cursor("SELECT *, DATE_FORMAT(SendingDateTime, '%d-%m-%y %H:%i:%S') as date  FROM outbox WHERE Status IN ('DeliveryOK','DeliveryFailed','DeliveryPending','DeliveryUnknown','Error','Reserved') ORDER BY SendingDateTime DESC LIMIT "..limit.." OFFSET "..offset)
	return db.results(cur)
end

function _M.count()
	local cur 
	cur = db.cursor("SELECT COUNT(*) as count FROM outbox WHERE Status IN ('DeliveryOK','DeliveryFailed','DeliveryPending','DeliveryUnknown','Error','Reserved')")	
	return db.results(cur)[1].count
end

function _M.add(data)
	return db.cursor("INSERT INTO outbox("..table.concat(db.keys(data),',')..") VALUES ("..db.escape(data)..")")
end

return _M
