local react = require(script.Parent.Parent.react)
local jecs = require(script.Parent.Parent.jecs)
local jecsUtils = require(script.Parent.Parent["jecs-utils"])

local useState = react.useState;
local useEffect = react.useEffect;

function useQuery<T...>(query: jecs.Query<...any>?, deps: { any }?): () -> { jecs.Entity }
	local entities = {} :: { jecs.Entity }
	local entityMap = {} :: { [jecs.Entity]: number }

	local state, setState = useState(entities)

	useEffect(function()
		table.clear(entities)
		table.clear(entityMap)
		if not query then
			setState(entities)
			return
		end
		for entity in query:iter() do
			table.insert(entities, entity)
			entityMap[entity] = #entities
		end
		setState(entities)

		local monitor = jecsUtils.monitor(query)
		monitor.added(function(entity)
			if entityMap[entity] then
				return
			end
			table.insert(entities, entity)
			entityMap[entity] = #entities
			setState(entities)
		end)

		monitor.removed(function(entity)
			task.defer(function()
				local index = entityMap[entity]
				if not index then
					return
				end
				entityMap[entity] = nil
				local latest = table.remove(entities)
				if not latest then
					setState(entities)
					return
				end
				if latest == entity then
					setState(entities)
					return
				end
				entities[index] = latest
				entityMap[latest] = index
				state(entities)
			end)
		end)

		return monitor.disconnect
	end, deps)

	return state
end

return useQuery
