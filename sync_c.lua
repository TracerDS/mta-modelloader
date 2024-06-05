local syncedModels = {}
local ids = {}

-- Request id for models
local function RequestTableModel(modelTbl, modelType)
    local tbl = {}
    for modelName, modelData in pairs(modelTbl or {}) do
        local id = ML.Funcs.RequestModel(modelType, modelName, modelData)
        table.insert(tbl, id)
    end
    return tbl
end

-- Request ids for synced models
-- and send ids to the server
local function RequestIDs()
    ids.vehicles = RequestTableModel(syncedModels.vehicles, 'vehicle')
    ids.peds = RequestTableModel(syncedModels.peds, 'ped')

    triggerServerEvent(resourceName..':SendSyncedIDs', resourceRoot, ids)
end

-- Sync incoming models
addEvent(resourceName..':SetSyncedModels', true)
addEventHandler(resourceName..':SetSyncedModels', localPlayer, function(models)
    assert(type(models) == 'table', 'Expected table in "modelloader:getModels", got '..type(models))
    syncedModels = models

    RequestIDs()
end)

-- When resource starts, request synced models
-- and request ids for them
addEventHandler('onClientResourceStart', resourceRoot, function()
    if not next(syncedModels) then
        triggerServerEvent(resourceName..':RequestSyncedModels', resourceRoot)
    end
    RequestIDs()
end)

-- When resource stops, free all allocated models
addEventHandler('onClientResourceStop', resourceRoot, function()
    for _,id in ipairs(ids.vehicles) do
        FreeModel(id)
    end
    for _,id in ipairs(ids.peds) do
        FreeModel(id)
    end
end)

-- Export functions --

function GetIDs()
    return ids
end
function GetModels()
    return syncedModels
end