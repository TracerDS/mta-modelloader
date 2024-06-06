ML.ReplacedModels = {
    ped = {},
    vehicle = {},
}
ML.ReplacedModelsID = {
    ped = {},
    vehicle = {},
}

-- Function for request ID for a model
ML.Funcs.RequestModel = function(modelType, modelName, modelData)
    local id = engineRequestModel(modelType)
    if not id then return end
    
    local modelTable = {}

    local col
    local txd
    local dff

    if modelData.col then
        col = engineLoadCOL(modelData.col)
        if col then
            engineReplaceCOL(col, id)
        end
    end
    if modelData.txd then
        txd = engineLoadTXD(modelData.txd)
        if txd then
            engineImportTXD(txd, id)
        end
    end
    if modelData.dff then
        dff = engineLoadDFF(modelData.dff)
        if dff then
            engineReplaceModel(dff, id)
        end
    end

    modelTable.id = id
    modelTable.modelName = modelName
    modelTable.col = col
    modelTable.txd = txd
    modelTable.dff = dff
    modelTable.config = modelData.config

    -- replaced model
    ML.ReplacedModels[modelType][modelName] = modelTable

    -- helper table used for getting the model by id
    ML.ReplacedModelsID[modelType][id] = modelName

    return id
end

-- Function for replacing a model
ML.Funcs.ReplaceModel = function(model, id)
    if not model or not isElement(model) then return end

    local modelType = getElementType(model)
    local modelTypeIDTable = ML.ReplacedModelsID[modelType]
    if not modelTypeIDTable then return end

    local modelName = modelTypeIDTable[id]
    if not modelName then return end

    local modelTypeTable = ML.ReplacedModels[modelType]
    if not modelTypeTable then return end

    local modelEntry = modelTypeTable[modelName]
    if not modelEntry then return end

    if modelType == 'vehicle' then
        for name, value in pairs(modelEntry.config) do
            if ML.Funcs.IsVehicleProperty(name) then
                if not setVehicleHandling(model, name, value) then
                    break
                end
            end
        end
    end
    if modelTypeTable == 'ped' then
        for name, value in pairs(modelEntry.config) then
            if ML.Funcs.IsWalkingStyle(name) then
                if not setPedWalkingStyle(model, value) then
                    break
                end
            end
            if ML.Funcs.IsPedStat(name) then
                if not setPedStat(model, name, value) then
                    break
                end
            end
            if ML.Funcs.IsPedVoice(name, value) then
                if not setPedVoice(model, name, value) then
                    break
                end
            end
        end
    end
    return setElementModel(model, id)
end

-- Free model id
ML.Funcs.FreeModel = function(id)
    return engineFreeModel(id)
end

-- Replace model
addEvent(resourceName..':ReplaceModel', true)
addEventHandler(resourceName..':ReplaceModel', localPlayer, function(model, id)
    if type(model) == 'table' then
        for _,entry in ipairs(model) do
            -- replace provided model with certain id
            ML.Funcs.ReplaceModel(entry, id)
        end
    end
    ML.Funcs.ReplaceModel(model, id)
end)

-- Export functions --

ReplaceModel = ML.Funcs.ReplaceModel
RequestModel = ML.Funcs.RequestModel
FreeModel = ML.Funcs.FreeModel