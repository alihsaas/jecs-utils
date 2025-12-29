local react = require(script.Parent.Parent.react)
local jecs = require(script.Parent.Parent.jecs)

local useWorld = require(script.Parent.useWorld).useWorld

local useState = react.useState;
local useEffect = react.useEffect;

function getTarget(world: jecs.World, entity: jecs.Entity?, relation: jecs.Id<any>): jecs.Entity?
	return if entity then world:target(entity, relation) else nil
end

function useTarget<T>(entity: jecs.Entity?, relation: jecs.Id<T>, deps: { any }?)
	local world = useWorld();
	local target, setTarget = useState(getTarget(world, entity, relation))

	useEffect(function()
		target(getTarget(world, entity, relation))
		if not entity then
			return
		end

		local addedDisconnect = world:added(relation, function(added)
			if added == entity then
				setTarget(getTarget(world, entity, relation))
			end
		end)
		local removedDisconnect = world:removed(relation, function(removed)
			if removed == entity then
				task.defer(function()
					setTarget(getTarget(world, entity, relation))
				end)
			end
		end)

		return function()
			addedDisconnect()
			removedDisconnect()
		end
	end, deps)

	return target
end

return useTarget
