
addCommandHandler('cveh', function(player, cmd, id)
    if not id then return end
    local x,y,z = getElementPosition(player)
    local veh = createVehicle(id, x,y+5,z+5)

    local ids = exports['modelloader']:GetIDs()
    exports['modelloader']:ReplaceModel(veh, ids[player].vehicles[1])
end)