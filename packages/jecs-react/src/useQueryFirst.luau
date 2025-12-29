local react = require(script.Parent.Parent.react)
local jecs = require(script.Parent.Parent.jecs)
local jecsUtils = require(script.Parent.Parent["jecs-utils"])

local queryFirst = jecsUtils.query_first

local useState = react.useState;
local useEffect = react.useEffect;

function useQueryFirst<T...>(query: jecs.Query<T...>, predicator: ((entity: jecs.Entity, T...) -> boolean)?, deps: { any }?)
	local current, setCurrent = useState(nil :: jecs.Entity?)

	useEffect(function()
		local query = query :: jecs.Query<...any>
		if not query then
			setCurrent(nil)
			return
		end
		local monitor = jecsUtils.monitor(query)

		monitor.added(function(e)
			task.defer(function()
				local first = queryFirst(query, predicator :: any)
				setCurrent(first)
			end)
		end)
		monitor.removed(function()
			task.defer(function()
				local first = queryFirst(query, predicator :: any)
				setCurrent(first)
			end)
		end)
		local first = queryFirst(query, predicator :: any)
		setCurrent(first)
		return monitor.disconnect
	end, deps)

	return current
end

return useQueryFirst
