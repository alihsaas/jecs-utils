local react = require(script.Parent.Parent.react)
local jecsUtils = require(script.Parent.Parent["jecs-utils"])
local jecs = require(script.Parent.Parent.jecs)

local WorldContext = react.createContext(nil)

local function WorldProvider(props)
    local world = props.world
    assert(world, "WorldProvider requires a 'world' prop (initialized Jecs world)")
    jecsUtils.world(world)
    return react.createElement(WorldContext.Provider, {
        value = world
    }, props.children)
end

local function useWorld(): jecs.World
    local world = react.useContext(WorldContext)
    assert(world, "useWorld must be used within a <WorldProvider>")
    return world
end

return {
    useWorld = useWorld,
    WorldProvider = WorldProvider
}