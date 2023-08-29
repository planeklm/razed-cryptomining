local QBCore = exports['qb-core']:GetCoreObject()

function CheckGTX480()
    if QBCore.Functions.HasItem('shitgpu') then
        return false
    else
        return true
    end
end

function CheckGTX1050()
    if QBCore.Functions.HasItem('1050gpu') then
        return false
    else
        return true
    end
end

function CheckGTX1060()
    if QBCore.Functions.HasItem('1060gpu') then
        return false
    else
        return true
    end
end

function CheckGTX1080()
    if QBCore.Functions.HasItem('1080gpu') then
        return false
    else
        return true
    end
end

function CheckRTX2080()
    if QBCore.Functions.HasItem('2080gpu') then
        return false
    else
        return true
    end
end

function CheckRTX3060()
    if QBCore.Functions.HasItem('3060gpu') then
        return false
    else
        return true
    end
end

function CheckRTX4090()
    if QBCore.Functions.HasItem('4090gpu') then
        return false
    else
        return true
    end
end

RegisterNetEvent('razed-cryptomining:client:useGTX480', function()
    local success = nil
    local gpu = 'shitgpu'
    local notif1 = {
        title = 'Installing Graphics Card',
        description = 'Please wait 15 seconds for the graphics card to be installed.',
        duration = '500',
        type = 'success'
    }
    local notif2 = {
        title = 'Successfully Installed Graphics Card!',
        description = 'Enjoy mining those cryptos!',
        duration = '500',
        type = 'success'
    }
    local notif3 = {
        title = 'Error',
        description = 'Something bad happened! Oh no!',
        duration = '500',
        type = 'error'
    }

    success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1}, 'easy'}, {'1', '2'})

    if success == true then
    ExecuteCommand("e mechanic")
    TriggerEvent("ox_lib:notify", notif1)
    if lib.progressCircle({
        duration = 15000,
        position = 'bottom',
        label = 'Install Graphics Card...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
    }) then
            TriggerEvent("ox_lib:notify", notif2)
            TriggerServerEvent('razed-cryptomining:server:sendGPUDatabase', gpu)
            ExecuteCommand("e c")
        else
            TriggerEvent("ox_lib:notify", notif3)
            ExecuteCommand("e c")
        end
else
    TriggerEvent("ox_lib:notify", notif3)
end
end
end
end)

RegisterNetEvent('razed-cryptomining:client:useGTX1050', function()
    local gpu = '1050gpu'
    local success = nil
    local notif1 = {
        title = 'Installing Graphics Card',
        description = 'Please wait 15 seconds for the graphics card to be installed.',
        duration = '500',
        type = 'success'
    }
    local notif2 = {
        title = 'Successfully Installed Graphics Card!',
        description = 'Enjoy mining those cryptos!',
        duration = '500',
        type = 'success'
    }
    local notif3 = {
        title = 'Error',
        description = 'Something bad happened! Oh no!',
        duration = '500',
        type = 'error'
    }

    success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1.5}, 'easy'}, {'1', '2', '3', '4'})

    if success == true then
    ExecuteCommand("e mechanic")
    TriggerEvent("ox_lib:notify", notif1)
    if lib.progressCircle({
        duration = 15000,
        position = 'bottom',
        label = 'Install Graphics Card...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
    }) then
            TriggerEvent("ox_lib:notify", notif2)
            TriggerServerEvent('razed-cryptomining:server:sendGPUDatabase', gpu)
            ExecuteCommand("e c")
        else
            TriggerEvent("ox_lib:notify", notif3)
            ExecuteCommand("e c")
        end
else
    TriggerEvent("ox_lib:notify", notif3)
end
end
end
end)

RegisterNetEvent('razed-cryptomining:client:useGTX1060', function()
    local gpu = '1060gpu'
    local success = nil
    local notif1 = {
        title = 'Installing Graphics Card',
        description = 'Please wait 15 seconds for the graphics card to be installed.',
        duration = '500',
        type = 'success'
    }
    local notif2 = {
        title = 'Successfully Installed Graphics Card!',
        description = 'Enjoy mining those cryptos!',
        duration = '500',
        type = 'success'
    }
    local notif3 = {
        title = 'Error',
        description = 'Something bad happened! Oh no!',
        duration = '500',
        type = 'error'
    }

    success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1.75}, 'easy'}, {'1', '2', '3', '4'})

    if success == true then
    ExecuteCommand("e mechanic")
    TriggerEvent("ox_lib:notify", notif1)
    if lib.progressCircle({
        duration = 15000,
        position = 'bottom',
        label = 'Install Graphics Card...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
    }) then
            TriggerEvent("ox_lib:notify", notif2)
            TriggerServerEvent('razed-cryptomining:server:sendGPUDatabase', gpu)
            ExecuteCommand("e c")
        else
            TriggerEvent("ox_lib:notify", notif3)
            ExecuteCommand("e c")
        end
else
    TriggerEvent("ox_lib:notify", notif3)
end
end
end
end)

RegisterNetEvent('razed-cryptomining:client:useGTX1080', function()
    local gpu = '1080gpu'
    local success = nil
    local notif1 = {
        title = 'Installing Graphics Card',
        description = 'Please wait 15 seconds for the graphics card to be installed.',
        duration = '500',
        type = 'success'
    }
    local notif2 = {
        title = 'Successfully Installed Graphics Card!',
        description = 'Enjoy mining those cryptos!',
        duration = '500',
        type = 'success'
    }
    local notif3 = {
        title = 'Error',
        description = 'Something bad happened! Oh no!',
        duration = '500',
        type = 'error'
    }

    success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'medium'}, {'1', '2', '3', '4'})

    if success == true then
    ExecuteCommand("e mechanic")
    TriggerEvent("ox_lib:notify", notif1)
    if lib.progressCircle({
        duration = 15000,
        position = 'bottom',
        label = 'Install Graphics Card...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
    }) then
            TriggerEvent("ox_lib:notify", notif2)
            TriggerServerEvent('razed-cryptomining:server:sendGPUDatabase', gpu)
            ExecuteCommand("e c")
        else
            TriggerEvent("ox_lib:notify", notif3)
            ExecuteCommand("e c")
        end
else
    TriggerEvent("ox_lib:notify", notif3)
end
end
end
end)

RegisterNetEvent('razed-cryptomining:client:useRTX2080', function()
    local gpu = '2080gpu'
    local success = nil
    local notif1 = {
        title = 'Installing Graphics Card',
        description = 'Please wait 15 seconds for the graphics card to be installed.',
        duration = '500',
        type = 'success'
    }
    local notif2 = {
        title = 'Successfully Installed Graphics Card!',
        description = 'Enjoy mining those cryptos!',
        duration = '500',
        type = 'success'
    }
    local notif3 = {
        title = 'Error',
        description = 'Something bad happened! Oh no!',
        duration = '500',
        type = 'error'
    }

    success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2.25}, 'medium'}, {'1', '2', '3', '4'})

    if success == true then
    ExecuteCommand("e mechanic")
    TriggerEvent("ox_lib:notify", notif1)
    if lib.progressCircle({
        duration = 15000,
        position = 'bottom',
        label = 'Install Graphics Card...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
    }) then
            TriggerEvent("ox_lib:notify", notif2)
            TriggerServerEvent('razed-cryptomining:server:sendGPUDatabase', gpu)
            ExecuteCommand("e c")
        else
            TriggerEvent("ox_lib:notify", notif3)
            ExecuteCommand("e c")
        end
else
    TriggerEvent("ox_lib:notify", notif3)
end
end
end
end)

RegisterNetEvent('razed-cryptomining:client:useRTX3060', function()
    local gpu = '3060gpu'
    local success = nil
    local notif1 = {
        title = 'Installing Graphics Card',
        description = 'Please wait 15 seconds for the graphics card to be installed.',
        duration = '500',
        type = 'success'
    }
    local notif2 = {
        title = 'Successfully Installed Graphics Card!',
        description = 'Enjoy mining those cryptos!',
        duration = '500',
        type = 'success'
    }
    local notif3 = {
        title = 'Error',
        description = 'Something bad happened! Oh no!',
        duration = '500',
        type = 'error'
    }

    success = lib.skillCheck({'easy', 'medium', {areaSize = 60, speedMultiplier = 2.5}, 'medium'}, {'1', '2', '3', '4'})

    if success == true then
    ExecuteCommand("e mechanic")
    TriggerEvent("ox_lib:notify", notif1)
    if lib.progressCircle({
        duration = 15000,
        position = 'bottom',
        label = 'Install Graphics Card...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
    }) then
            TriggerEvent("ox_lib:notify", notif2)
            TriggerServerEvent('razed-cryptomining:server:sendGPUDatabase', gpu)
            ExecuteCommand("e c")
        else
            TriggerEvent("ox_lib:notify", notif3)
            ExecuteCommand("e c")
        end
else
    TriggerEvent("ox_lib:notify", notif3)
end
end
end
end)

RegisterNetEvent('razed-cryptomining:client:useRTX4090', function()
    local gpu = '4090gpu'
    local success = nil
    local notif1 = {
        title = 'Installing Graphics Card',
        description = 'Please wait 15 seconds for the graphics card to be installed.',
        duration = '500',
        type = 'success'
    }
    local notif2 = {
        title = 'Successfully Installed Graphics Card!',
        description = 'Enjoy mining those cryptos!',
        duration = '500',
        type = 'success'
    }
    local notif3 = {
        title = 'Error',
        description = 'Something bad happened! Oh no!',
        duration = '500',
        type = 'error'
    }

    success = lib.skillCheck({'easy', 'medium', {areaSize = 60, speedMultiplier = 3}, 'hard'}, {'1', '2', '3', '4'})

    if success == true then
    ExecuteCommand("e mechanic")
    TriggerEvent("ox_lib:notify", notif1)
    if lib.progressCircle({
        duration = 15000,
        position = 'bottom',
        label = 'Install Graphics Card...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
    }) then
            TriggerEvent("ox_lib:notify", notif2)
            TriggerServerEvent('razed-cryptomining:server:sendGPUDatabase', gpu)
            ExecuteCommand("e c")
        else
            TriggerEvent("ox_lib:notify", notif3)
            ExecuteCommand("e c")
        end
else
    TriggerEvent("ox_lib:notify", notif3)
end
end
end
end)
