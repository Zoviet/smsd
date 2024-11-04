local _M = {}
local db = require('db.mysql')

function _M.get(limit,offset)
	local cur 
	if offset == nil then offset = 0 end
	if offset == nil then limit = 200 end
	cur = db.cursor("SELECT *, DATE_FORMAT(ReceivingDateTime, '%d-%m-%y %H:%i:%S') as date FROM inbox ORDER BY ReceivingDateTime DESC LIMIT "..limit.." OFFSET "..offset)	
	return db.results(cur)
end

function _M.count()
	local cur 
	cur = db.cursor("SELECT COUNT(*) as count FROM inbox")	
	return db.results(cur)[1].count
end

return _M
