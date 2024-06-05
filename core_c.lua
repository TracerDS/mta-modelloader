ML.ReplacedModels = {}
ML.ReplacedModelsID = {}

-- Function for request ID for a model
ML.Funcs.RequestModel = function(modelType, modelName, modelData)
    local id = engineRequestModel(modelType)
    if not id then return end
    
    ML.ReplacedModels[modelName] = {}

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

    ML.ReplacedModels[modelName].id = id
    ML.ReplacedModels[modelName].modelName = modelName
    ML.ReplacedModels[modelName].col = col
    ML.ReplacedModels[modelName].txd = txd
    ML.ReplacedModels[modelName].dff = dff
    ML.ReplacedModels[modelName].config = modelData.config

    ML.ReplacedModelsID[id] = modelName

    return id
end

-- Function for replacing a model
ML.Funcs.ReplaceModel = function(model, id)
    if not model or not isElement(model) then return end

    if getElementType(model) == 'vehicle' then
        local modelName = ML.ReplacedModelsID[id]
        if not modelName then return end

        local modelEntry = ML.ReplacedModels[modelName]
        if not modelEntry then return end

        for name, value in pairs(modelEntry.config) do
            if not setVehicleHandling(model, name, value) then
                break
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
            ML.Funcs.ReplaceModel(entry, id)
        end
    end
    ML.Funcs.ReplaceModel(model, id)
end)

-- Export functions --

ReplaceModel = ML.Funcs.ReplaceModel
RequestModel = ML.Funcs.RequestModel
FreeModel = ML.Funcs.FreeModel