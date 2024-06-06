local syncedIds = {}

-- Send synced models to player
local function SendSyncedModels(player)
    triggerClientEvent(player, resourceName..':SendSyncedModels', player, GetModels())
end

-- Send synced models to a player
-- requesting models
addEvent(resourceName..':RequestSyncedModels', true)
addEventHandler(resourceName..':RequestSyncedModels', resourceRoot, function()
    SendSyncedModels(client)
end)

-- Sync incoming model ids
addEvent(resourceName..':SendSyncedIDs', true)
addEventHandler(resourceName..':SendSyncedIDs', resourceRoot, function(ids)
    if not client then return end
    syncedIds[client] = ids
end)

-- When player joins, send synced models
addEventHandler('onPlayerResourceStart', root, function(res)
    if res ~= resource then return end
    SendSyncedModels(source)
end)

-- Export functions --

function GetIDs(playerToFetch)
    if playerToFetch then
        return syncedIds[playerToFetch]
    end
    return syncedIds
end