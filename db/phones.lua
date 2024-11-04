local _M = {}
local db = require('db.mysql')

function _M.get(limit,offset)
	local cur 
	if offset == nil then offset = 0 end
	if offset == nil then limit = 200 end
	cur = db.cursor("SELECT *, DATE_FORMAT(UpdatedInDB, '%d-%m-%y %H:%i:%S') as updated FROM phones ORDER BY InsertIntoDB DESC LIMIT "..limit.." OFFSET "..offset)
	return db.results(cur)
end

function _M.getIds()
	local cur 
	cur = db.cursor("SELECT ID FROM phones WHERE Send='yes' ORDER BY InsertIntoDB DESC")
	return db.results(cur)
end

function _M.count()
	local cur 
	cur = db.cursor("SELECT COUNT(*) as count FROM phones")	
	return db.results(cur)[1].count
end

return _M
