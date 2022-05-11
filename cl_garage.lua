local QBCore = exports['qb-core']:GetCoreObject()
local cam
local lastpos
local veh

CreateThread(function()
    
    while true do

        Wait(0)

        local PlayerCoords = GetEntityCoords(PlayerPedId())

        if QBCore.Functions.GetPlayerData().job.name == "police" then

            if Vdist(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 459.0, -1017.19, 28.16) < 1.5 then

                DrawText3D(459.0, -1017.19, 28.16 , '[E] Police Garage')

                if IsControlJustPressed(0, 38) then

                    TriggerEvent("qb-policegarage:openUI")

                end

            end

        end
    
    end

end)

function openUI(data,index,cb)

    local plyPed = PlayerPedId()

    lastpos = GetEntityCoords(plyPed)

    SetEntityCoords(plyPed, 453.16662, -1024.837, 28.514112)

    SetEntityVisible(plyPed, false)

    SetNuiFocus(true, true)

end

RegisterNUICallback("showVeh", function(data,cb)

    local pos = Config.viewcoords

    if DoesEntityExist(veh) then

        DeleteEntity(veh)

        while DoesEntityExist(veh) do Wait(250) end

    end

    RequestModel(data.model)

    while not HasModelLoaded(data.model) do Wait(100) end

    veh = CreateVehicle(data.model, pos.x, pos.y, pos.z, 62.03, false, false)

    SetVehicleModKit(veh, 0)
    SetEntityAlpha(veh, 85)

end)

RegisterNetEvent("qb-policegarage:client:spawn",function(model,spawnLoc,spawnHeading)
    local ped = PlayerPedId()
    RequestModel(model)

    while not HasModelLoaded(model) do Wait(100) end

    local veh = CreateVehicle(model, spawnLoc.x, spawnLoc.y, spawnLoc.z, spawnHeading, true, true)
    
    SetVehicleNumberPlateText(model, plate)
    exports['LegacyFuel']:SetFuel(veh, 100.0)
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
    SetEntityHeading(veh, spawnHeading)
    SetVehicleEngineOn(veh, true, true)
    SetVehicleModKit(veh, 0)
 
end)

RegisterNUICallback("buy", function(data,cb)

    SendNUIMessage({

        action = 'close'

    })

    TriggerServerEvent('qb-policegarage:server:takemoney', data)

    SetEntityCoords(PlayerPedId(), lastpos.x, lastpos.y, lastpos.z)

    SetEntityVisible(PlayerPedId(), true)

    DeleteEntity(veh)

    DoScreenFadeOut(500)

    Wait(500)

    RenderScriptCams(false, false, 1, true, true)

    DestroyAllCams(true)

    SetNuiFocus(false, false)

    DoScreenFadeIn(500)

    Wait(500)
    
    TriggerEvent('qb-policegarage:client:SaveCar')
end)

RegisterNUICallback("close", function()

    SetEntityCoords(PlayerPedId(), lastpos.x, lastpos.y, lastpos.z)

    SetEntityVisible(PlayerPedId(), true)

    DeleteEntity(veh)

    DoScreenFadeOut(500)
    
    Wait(500)

    RenderScriptCams(false, false, 1, true, true)

    DestroyAllCams(true)

    SetNuiFocus(false, false)

    DoScreenFadeIn(500)

    Wait(500)

end)


RegisterNetEvent('qb-policegarage:client:SaveCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)

    if veh ~= nil and veh ~= 0 then
        local plate = QBCore.Functions.GetPlate(veh)
        local props = QBCore.Functions.GetVehicleProperties(veh)
        local hash = props.model
        local vehname = GetDisplayNameFromVehicleModel(hash):lower()
        if QBCore.Shared.Vehicles[vehname] ~= nil and next(QBCore.Shared.Vehicles[vehname]) ~= nil then
            TriggerServerEvent('qb-policegarage:server:SaveCarData', props, QBCore.Shared.Vehicles[vehname], `veh`, plate)
        else
            QBCore.Functions.Notify('You cant store this vehicle in your garage..', 'error')
        end
    else
        QBCore.Functions.Notify('You are not in a vehicle..', 'error')
    end
end)


RegisterNetEvent("qb-policegarage:openUI",function()

    changeCam()

    for i = 1,#Config.Garage do

        SendNUIMessage({

            action = true,

            index = i,

            vehicleInfo = Config.Garage[i].vehicles

        })

        openUI(Config.Garage[i].vehicles, i)
        
    end

end)

function changeCam()

    DoScreenFadeOut(500)

    Wait(1000)

    if not DoesCamExist(cam) then

        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    end

    SetCamActive(cam, true)

    SetCamRot(cam,vector3(-10.0,0.0, -155.999), true)
    
    SetCamFov(cam,80.0)

    SetCamCoord(cam, vector3(451.19, -1014.72, 29.97))

    PointCamAtCoord(cam, vector3(451.19, -1014.72, 29.97))

    RenderScriptCams(true, false, 2500.0, true, true)

    DoScreenFadeIn(1000)

    Wait(1000)

end

DrawText3D = function(x, y, z, text)

	SetTextScale(0.35, 0.35)

    SetTextFont(4)

    SetTextProportional(1)

    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")

    SetTextCentre(true)

    AddTextComponentString(text)

    SetDrawOrigin(x,y,z, 0)

    DrawText(0.0, 0.0)

    local factor = (string.len(text)) / 370

    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)

    ClearDrawOrigin()

end