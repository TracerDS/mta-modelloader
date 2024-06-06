local models = {}

-- Read directory and look for
-- model files (.txd, .dff, .col, .conf)
local function ReadDir(path)
    local tbl = {}
    for _,entry in ipairs(pathListDir(path)) do
        local modelName
        do
            local offset = entry:find('%.')
            if not offset then
                modelName = entry
            end
            modelName = entry:sub(1, offset-1)
        end
        
        if entry:endswith('.txd') then
            local txd = GetFileData(path..'/'..entry)
    
            if not tbl[modelName] then
                tbl[modelName] = {}
            end

            tbl[modelName].txd = txd
        end
        if entry:endswith('.dff') then
            local dff = GetFileData(path..'/'..entry)
    
            if not tbl[modelName] then
                tbl[modelName] = {}
            end

            tbl[modelName].dff = dff
        end
        if entry:endswith('.col') then
            local col = GetFileData(path..'/'..entry)
    
            if not tbl[modelName] then
                tbl[modelName] = {}
            end

            tbl[modelName].col = col
        end
        -- special: For vehicles and peds only
        if entry:endswith('.conf') then
            local config

            local xml = xmlLoadFile(path..'/'..entry)
            if xml then
                for _,node in ipairs(xmlNodeGetChildren(xml) or {}) do
                    -- load data for model
                    local propName, propValue = ML.Funcs.XML.LoadData(node)
                    if propName and propValue then
                        config[propName] = propValue
                    end
                end

                xmlUnloadFile(xml)
            end

            if not tbl[modelName] then
                tbl[modelName] = {}
            end

            tbl[modelName].config = config
        end
    end
    return tbl
end

-- When resource starts, read model directory
addEventHandler('onResourceStart', resourceRoot, function()
    models.vehicles = ReadDir('models/vehicles')
    models.peds = ReadDir('models/peds')
end)

-- Export functions --

function ReplaceModel(model, id)
    return triggerClientEvent(root, resourceName..':ReplaceModel', root, model, id)
end

function GetModels()
    return models
end