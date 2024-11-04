local _M = {}
local db = require('db.mysql')

function _M.getSent(limit,offset)
	local cur 
	if offset == nil then offset = 0 end
	if offset == nil then limit = 200 end
	cur = db.cursor("SELECT *, DATE_FORMAT(SendingDateTime, '%d-%m-%y %H:%i:%S') as date  FROM sentitems WHERE Status IN ('SendingOK','SendingOKNoReport') ORDER BY SendingDateTime DESC LIMIT "..limit.." OFFSET "..offset)
	return db.results(cur)
end

function _M.countSent()
	local cur 
	cur = db.cursor("SELECT COUNT(*) as count FROM sentitems WHERE Status IN ('SendingOK','SendingOKNoReport')")	
	return db.results(cur)[1].count
end

function _M.getNotSent(limit,offset)
	local cur 
	if offset == nil then offset = 0 end
	if offset == nil then limit = 200 end
	cur = db.cursor("SELECT *, DATE_FORMAT(SendingDateTime, '%d-%m-%y %H:%i:%S') as date  FROM sentitems WHERE Status IN ('SendingError','Error') ORDER BY SendingDateTime DESC LIMIT "..limit.." OFFSET "..offset)
	return db.results(cur)
end

function _M.countNotSent()
	local cur 
	cur = db.cursor("SELECT COUNT(*) as count FROM sentitems WHERE Status IN ('SendingError','Error')")	
	return db.results(cur)[1].count
end

return _M
