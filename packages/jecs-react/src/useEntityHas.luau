local react = require(script.Parent.Parent.react)
local jecs = require(script.Parent.Parent.jecs)
local useWorld = require(script.Parent.useWorld).useWorld

local useState = react.useState;
local useEffect = react.useEffect;

function getTag(entity: jecs.Entity?, tag: jecs.Entity)
	return if entity then useWorld():has(entity, tag) else false
end

function useEntityHas(entity: jecs.Entity?, tag: jecs.Entity, deps: { any }?)
	local isTagged, setTagged = useState(getTag(entity, tag))

	local world = useWorld()

	useEffect(function()
		setTagged(getTag(entity, tag))
		local addedDisconnect = world:added(tag, function(added)
			if added == entity then
				setTagged(getTag(entity, tag))
			end
		end)
		local removedDisconnect = world:removed(tag, function(removed)
			if removed == entity then
				task.defer(function()
					setTagged(getTag(entity, tag))
				end)
			end
		end)

		return function()
			addedDisconnect()
			removedDisconnect()
		end
	end, deps)

	return isTagged
end

return useEntityHas
