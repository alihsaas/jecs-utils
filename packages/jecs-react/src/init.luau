local useEntityGet = require(script.useEntityGet)
local useEntityHas = require(script.useEntityHas)
local useQuery = require(script.useQuery)
local useQueryFirst = require(script.useQueryFirst)
local useTarget = require(script.useTarget)
local useWorld = require(script.useWorld)

local jecsReact = {
	useEntityGet = useEntityGet,
	useEntityHas = useEntityHas,
	useQueryFirst = useQueryFirst,
	useQuery = useQuery,
	useTarget = useTarget,
	useWorld = useWorld.useWorld,
	WorldProvider = useWorld.WorldProvider
}

return jecsReact
