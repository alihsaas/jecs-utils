local react = require(script.Parent.Parent.react)
local jecs = require(script.Parent.Parent.jecs)
local jecsUtils = require(script.Parent.Parent["jecs-utils"])

local useState = react.useState;
local useEffect = react.useEffect;

function useQuery<T...>(query: jecs.Query<...any>?, deps: { any }?): () -> { jecs.Entity }
    local state, setState = useState({} :: { jecs.Entity })
    
    useEffect(function()
        if not query then
            setState({})
            return
        end
        
        local entities = {} :: { jecs.Entity }
        local entityMap = {} :: { [jecs.Entity]: number }
        
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
            
            local newEntities = table.clone(entities)
            table.insert(newEntities, entity)
            entityMap[entity] = #newEntities
            entities = newEntities
            setState(newEntities)
        end)
        
        monitor.removed(function(entity)
            local index = entityMap[entity]
            if not index then
                return
            end

            local newEntities = table.clone(entities)
            entityMap[entity] = nil
            local latest = table.remove(newEntities)
            
            if latest and latest ~= entity then
                newEntities[index] = latest
                entityMap[latest] = index
            end
            
            entities = newEntities
            setState(newEntities)
        end)
        
        return monitor.disconnect
    end, deps)
    
    return state
end

return useQuery
