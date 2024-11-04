local _M = {}
local luasql = require "luasql.mysql"
local db = "smsd"
local db_user = "smsd"
local db_password = ""	
local env = assert(luasql.mysql())
local con = assert(env:connect(db,db_user,db_password))

function _M.cursor(data)
	return assert(con:execute(data))
end

function _M.results(cur)	
	local results = {}
	if not cur then return results end
	local i = 1
	row = cur:fetch({},"a")
	while row do
		results[i] = {}
		for key,val in pairs(row) do
			results[i][key] = val
		end
		row = cur:fetch (row, "a")
		i = i + 1
	end
	cur:close()
	env:close()
	return results
end

function _M.keys(t)
  local keys = {}
  for key,_ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

function _M.escape(t)
    local escaped 
	local _accum_0 = { }
	local _len_0 = 1
	for _,val in pairs(t) do
		if val == ngx.NULL then
			_accum_0[_len_0] = "NULL"
		else
			local _exp_0 = type(val)
			if "number" == _exp_0 then
				_accum_0[_len_0] = tostring(val)
			elseif "string" == _exp_0 then
				_accum_0[_len_0] = '"' .. val:gsub('"', [[\"]]) .. '"'
			elseif "boolean" == _exp_0 then
				_accum_0[_len_0] = val and "true" or "false"
			end      
		end
		_len_0 = _len_0 + 1
	end
	escaped = _accum_0
    return tostring(table.concat(escaped, ","))
 end

return _M
