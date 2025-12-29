local react = require(script.Parent.Parent.react)
local jecs = require(script.Parent.Parent.jecs)
local useWorld = require(script.Parent.useWorld).useWorld

local useState = react.useState;
local useEffect = react.useEffect;

function getComponent<T>(entity: jecs.Entity?, id: jecs.Entity<T>): T?
	return if entity then useWorld():get(entity, id) else nil
end

function useEntityGet<T>(entity: jecs.Entity?, id: jecs.Entity<T>, deps: { any }?): () -> T?
	local output, setOutput = useState()

	local world = useWorld()

	useEffect(function()
		setOutput(getComponent(entity, id))
		local component = jecs.IS_PAIR(id) and jecs.pair_first(world, id) or id
		local second = jecs.IS_PAIR(id) and jecs.pair_second(world, id) or nil

		local addedDisconnect = world:added(component, function(e, _, value)
			if e == entity then
				setOutput(getComponent(entity, id))
			end
		end)
		local changedDisconnect = world:changed(component, function(e, _, value)
			if e == entity then
				setOutput(getComponent(entity, id))
			end
		end)
		local removedDisconnect = world:removed(component, function(e, removed)
			if e ~= entity then
				return
			end
			if second == jecs.Wildcard and jecs.IS_PAIR(removed) then
				local value = nil
				local index = 0

				while true do
					local target = world:target(e, component, index)
					if not target then
						break
					end
					index += 1

					if target == jecs.pair_second(world, removed) then
						continue
					end
					value = world:get(e, jecs.pair(component, target))
					break
				end
				setOutput(value)
			else
				if removed == id then
					setOutput(nil)
				end
			end
		end)

		return function()
			addedDisconnect()
			changedDisconnect()
			removedDisconnect()
		end
	end, deps)

	return output
end

return useEntityGet
