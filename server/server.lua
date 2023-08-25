local QBCore = exports['qb-core']:GetCoreObject()
local CryptoBalance = 0.0
local MinerStatus = false
local defaultCard = 'shitgpu'

local function getData(citizenid)
    local data = MySQL.Sync.prepare('SELECT * FROM cryptominers where citizenid = ?', { citizenid })
    return data
end

local function getGPU(citizenid, card)
    local dataGPU = MySQL.Sync.prepare('SELECT * FROM cryptominers where card = ?', { card })
    local dataCitizen = MySQL.Sync.prepare('SELECT * FROM cryptominers where citizenid = ?', { citizenid })
    return dataGPU, dataCitizen
end

RegisterNetEvent('razed-cryptomining:server:buyCryptoMiner', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local notif1 = {
        title = 'Payment Success',
        description = 'You have successfully purcashed the crypto miner in cash.',
        type = 'success'
    }
    local notif2 = {
        title = 'Payment Success',
        description = 'You have successfully purcashed the crypto miner with your bank.',
        type = 'success'
    }
    local notif3 = {
        title = 'Payment Failed',
        description = 'You have insuffient funds either in your bank or cash.',
        type = 'error'
    }

    if Player.PlayerData.money.cash >= Config.Price['Stage 1'] then
        TriggerClientEvent("ox_lib:notify", src, notif1)
        Player.Functions.RemoveMoney('cash', Config.Price['Stage 1'], "Bought Stage 1 Crypto Miner")
        local id = MySQL.insert('INSERT INTO `cryptominers` (citizenid, card) VALUES (?, ?)',
            { Player.PlayerData.citizenid, defaultCard  })
        TriggerClientEvent('razed-cryptomining:client:addinfo', src, getData(Player.PlayerData.citizenid))
    elseif Player.PlayerData.money.bank >= Config.Price['Stage 1'] then
        TriggerClientEvent("ox_lib:notify", src, notif1)
        Player.Functions.RemoveMoney('bank', Config.Price['Stage 1'], "Bought Stage 1 Crypto Miner")
        local id = MySQL.insert('INSERT INTO `cryptominers` (citizenid, card) VALUES (?, ?)',
        { Player.PlayerData.citizenid, defaultCard })
        TriggerClientEvent('razed-cryptomining:client:addinfo', src, getData(Player.PlayerData.citizenid))
    else 
        TriggerClientEvent("ox_lib:notify", src, notif3)
    end
end)

RegisterNetEvent('razed-cryptomining:server:getinfo', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local data = getData(Player.PlayerData.citizenid)
    TriggerClientEvent('razed-cryptomining:client:addinfo', src, data)
end)

RegisterNetEvent('razed-cryptomining:server:withdrawcrypto', function()
    local notif1 = {
        title = 'Withdrawal Failed',
        description = 'You have insuffient withdrawal funds. Keep mining!',
        duration = '500',
        type = 'error'
    }
    local notif2 = {
        title = 'Withdrawal Successfull',
        description = 'The funds have been successfully withdrew! '..CryptoBalance..' coins collected, with a '..Config.CryptoWithdrawalFeeShown..'% fee.',
        duration = '500',
        type = 'success'
    }

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local data = getData(Player.PlayerData.citizenid)

if Config.Crypto == 'qb' then
    if CryptoBalance > 0.001 then 
    Player.Functions.AddMoney('crypto', CryptoBalance * Config.CryptoWithdrawalFee)
    CryptoBalance = CryptoBalance - CryptoBalance
    TriggerClientEvent("ox_lib:notify", src, notif2)
    else if CryptoBalance < 0.001 then
        TriggerClientEvent("ox_lib:notify", src, notif1)
    else
    TriggerClientEvent("ox_lib:notify", src, notif1)
    end
end
else if Config.Crypto == 'renewed-phone' then
    if CryptoBalance > 0.01 then 
        exports['qb-phone']:AddCrypto(src, Config.RenewedCryptoType, CryptoBalance * Config.CryptoWithdrawalFee)
        CryptoBalance = CryptoBalance - CryptoBalance
        TriggerClientEvent("ox_lib:notify", src, notif2)
        else if CryptoBalance < 0.0001 then
            TriggerClientEvent("ox_lib:notify", src, notif1)
        else
        TriggerClientEvent("ox_lib:notify", src, notif1)
        end
    end
  end
 end
end)

RegisterNetEvent('razed-cryptomining:server:switch',function(switchStatus)
    MinerStatus = switchStatus
end)

AddEventHandler('playerDropped', function()
    MinerStatus = false
end)

RegisterNetEvent('razed-cryptomining:server:sendGPUDatabase', function(gpu)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if gpu == nil then
        print('Attempted!')
    else
    local id = MySQL.update.await('UPDATE cryptominers SET card = ? WHERE citizenid = ?', {
        gpu, Player.PlayerData.citizenid
    })
    Player.Functions.RemoveItem(gpu, 1)
end
end)

RegisterNetEvent('razed-cryptomining:server:miningSystem', function()
local src = source
local Player = QBCore.Functions.GetPlayer(src)
local PlayerCitizenID = Player.PlayerData.citizenid

CreateThread(function()
if getGPU(PlayerCitizenID,'shitgpu')  then
    local mathRandom = math.random(1, 3) / 10
        while true do
            Wait(1000)
            while MinerStatus do
                Wait(math.random(15000, 50000))
                CryptoBalance = CryptoBalance + mathRandom
                Wait(math.random(2500, 10000))
            end
        end
    else if getGPU(PlayerCitizenID, '1050gpu') then
            local mathRandom = math.random(2, 6) / 10
                while true do
                    Wait(1000)
                    while MinerStatus do
                        Wait(math.random(12500, 40000))
                        CryptoBalance = CryptoBalance + mathRandom
                        Wait(math.random(1500, 8000))
                    end
                end
            else if getGPU(PlayerCitizenID, '1060gpu') then
                local mathRandom = math.random(3, 7) / 10
                    while true do
                        Wait(1000)
                        while MinerStatus do
                            Wait(math.random(10000, 35000))
                            CryptoBalance = CryptoBalance + mathRandom
                            Wait(math.random(1500, 8000))
                        end
                    end
                else if getGPU(PlayerCitizenID, '1080gpu') then
                    local mathRandom = math.random(5, 10) / 10
                        while true do
                            Wait(1000)
                            while MinerStatus do
                                Wait(math.random(8000, 30000))
                                CryptoBalance = CryptoBalance + mathRandom
                                Wait(math.random(1000, 6500))
                            end
                        end
                    else if getGPU(PlayerCitizenID, '2080gpu') then
                        local mathRandom = math.random(7, 11) / 10
                            while true do
                                Wait(1000)
                                while MinerStatus do
                                    Wait(math.random(7500, 27500))
                                    CryptoBalance = CryptoBalance + mathRandom
                                    Wait(math.random(800, 4500))
                                end
                            end
                    else if getGPU(PlayerCitizenID, '3060gpu') then
                        local mathRandom = math.random(10, 15) / 10
                            while true do
                                Wait(1000)
                                while MinerStatus do
                                    Wait(math.random(5500, 20500))
                                    CryptoBalance = CryptoBalance + mathRandom
                                    Wait(math.random(600, 2500))
                                end
                            end
                else if getGPU(PlayerCitizenID, '4090gpu') then
                    local mathRandom = math.random(20, 40) / 8
                        while true do
                            Wait(1000)
                            while MinerStatus do
                                Wait(math.random(2500, 18500))
                                CryptoBalance = CryptoBalance + mathRandom
                                Wait(math.random(300, 1500))
                            end
                        end
                    end
                    end      
                end
            end
        end
    end
 end
end)
end)
