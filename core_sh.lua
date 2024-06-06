resourceName = getResourceName(resource)

string.endswith = function(self, ending)
	return ending == '' or self:sub(-#ending) == ending
end

GetFileData = function(path)
	local file = fileOpen(path, true)
	if not file then return end

	local size = fileGetSize(file)
	if not size then return end

	local content = fileRead(file, size)
	fileClose(file)
	return content
end

ML = {}
ML.Funcs = {}
ML.Const = {
	VehicleID = 400,
	PedID = 7,
	ObjectID = 1337,
	ClumpModels = 3425,
	TimedObjects = 4715
}

ML.Funcs.CreateModel = function(modelType, ...)
	assert(type(modelType) == 'string', 'Expected string at argument 1, got '..type(modelType))
    modelType = modelType:lower()
	local model
    if modelType == 'vehicle' then
        model = createVehicle(ML.Const.VehicleID, ...)
    elseif modelType == 'ped' then
        model = createPed(ML.Const.PedID, ...)
    elseif modelType == 'object' then
        model = createObject(ML.Const.ObjectID, ...)
    end
end

CreateModel = ML.Funcs.CreateModel

ML.Funcs.XML = {}
ML.Funcs.XML.LoadData = function(node)
	local propertyName = xmlNodeGetAttribute(node, 'name')
	local propertyValue = xmlNodeGetAttribute(node, 'value')

	-- vehicle data
	if ML.Const.VehicleProperties[propertyName] then
		return propertyName, propertyValue
	end

	-- ped data
	if ML.Const.PedStats[propertyName] ~= nil then
		return propertyName, propertyValue
	end
	if ML.Const.WalkingStyles[propertyName] ~= nil then
		return propertyName, propertyValue
	end
	if ML.Const.PedVoices[propertyName] then
		if ML.Const.PedVoices[propertyName][propertyValue] then
			return propertyName, propertyValue
		end
	end
end