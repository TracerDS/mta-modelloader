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
        -- special: For vehicles only
        if entry:endswith('.conf') then
            local config = {}

            local xml = xmlLoadFile(path..'/'..entry)
            if xml then
                for _,node in ipairs(xmlNodeGetChildren(xml) or {}) do
                    local propertyName = xmlNodeGetAttribute(node, 'name')
                    local propertyValue = xmlNodeGetAttribute(node, 'value')

                    if propertyName == 'mass' then
                        config.mass = propertyValue
                    end
                    if propertyName == 'turnMass' then
                        config.turnMass = propertyValue
                    end
                    if propertyName == 'dragCoeff' then
                        config.dragCoeff = propertyValue
                    end
                    if propertyName == 'centerOfMass' then
                        config.centerOfMass = propertyValue
                    end
                    if propertyName == 'percentSubmerged' then
                        config.percentSubmerged = propertyValue
                    end
                    if propertyName == 'tractionMultiplier' then
                        config.tractionMultiplier = propertyValue
                    end
                    if propertyName == 'tractionLoss' then
                        config.tractionLoss = propertyValue
                    end
                    if propertyName == 'tractionBias' then
                        config.tractionBias = propertyValue
                    end
                    if propertyName == 'numberOfGears' then
                        config.numberOfGears = propertyValue
                    end
                    if propertyName == 'maxVelocity' then
                        config.maxVelocity = propertyValue
                    end
                    if propertyName == 'engineAcceleration' then
                        config.engineAcceleration = propertyValue
                    end
                    if propertyName == 'engineInertia' then
                        config.engineInertia = propertyValue
                    end
                    if propertyName == 'driveType' then
                        config.driveType = propertyValue
                    end
                    if propertyName == 'engineType' then
                        config.engineType = propertyValue
                    end
                    if propertyName == 'brakeDeceleration' then
                        config.brakeDeceleration = propertyValue
                    end
                    if propertyName == 'brakeBias' then
                        config.brakeBias = propertyValue
                    end
                    if propertyName == 'ABS' then
                        config.ABS = propertyValue
                    end
                    if propertyName == 'steeringLock' then
                        config.steeringLock = propertyValue
                    end
                    if propertyName == 'suspensionForceLevel' then
                        config.suspensionForceLevel = propertyValue
                    end
                    if propertyName == 'suspensionDamping' then
                        config.suspensionDamping = propertyValue
                    end
                    if propertyName == 'suspensionHighSpeedDamping' then
                        config.suspensionHighSpeedDamping = propertyValue
                    end
                    if propertyName == 'suspensionUpperLimit' then
                        config.suspensionUpperLimit = propertyValue
                    end
                    if propertyName == 'suspensionLowerLimit' then
                        config.suspensionLowerLimit = propertyValue
                    end
                    if propertyName == 'suspensionFrontRearBias' then
                        config.suspensionFrontRearBias = propertyValue
                    end
                    if propertyName == 'suspensionAntiDiveMultiplier' then
                        config.suspensionAntiDiveMultiplier = propertyValue
                    end
                    if propertyName == 'seatOffsetDistance' then
                        config.seatOffsetDistance = propertyValue
                    end
                    if propertyName == 'collisionDamageMultiplier' then
                        config.collisionDamageMultiplier = propertyValue
                    end
                    if propertyName == 'monetary' then
                        config.monetary = propertyValue
                    end
                    if propertyName == 'modelFlags' then
                        config.modelFlags = propertyValue
                    end
                    if propertyName == 'handlingFlags' then
                        config.handlingFlags = propertyValue
                    end
                    if propertyName == 'headLight' then
                        config.headLight = propertyValue
                    end
                    if propertyName == 'tailLight' then
                        config.tailLight = propertyValue
                    end
                    if propertyName == 'animGroup' then
                        config.animGroup = propertyValue
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