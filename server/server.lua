local QBCore = exports['qb-core']:GetCoreObject()
local CryptoBalance = 0.0
local MinerStatus = false

local function getData(citizenid)
    local data = MySQL.Sync.prepare('SELECT * FROM cryptominers where citizenid = ?', { citizenid })
    return data
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
        local id = MySQL.insert('INSERT INTO `cryptominers` (citizenid) VALUES (?)',
            { Player.PlayerData.citizenid })
        TriggerClientEvent('razed-cryptomining:client:addinfo', src, getData(Player.PlayerData.citizenid))
    elseif Player.PlayerData.money.bank >= Config.Price['Stage 1'] then
        TriggerClientEvent("ox_lib:notify", src, notif1)
        Player.Functions.RemoveMoney('bank', Config.Price['Stage 1'], "Bought Stage 1 Crypto Miner")
        local id = MySQL.insert('INSERT INTO `cryptominers` (citizenid) VALUES (?)',
        { Player.PlayerData.citizenid })
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
    if CryptoBalance > 0.001 then 
        exports['qb-phone']:AddCrypto(src, Config.RenewedCryptoType, CryptoBalance * Config.CryptoWithdrawalFee)
        CryptoBalance = CryptoBalance - CryptoBalance
        TriggerClientEvent("ox_lib:notify", src, notif2)
        else if CryptoBalance < 0.001 then
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

CreateThread(function()
   while true do
        Wait(1000)
        while MinerStatus do
            Wait(500)
            CryptoBalance = CryptoBalance + math.random(1, 3)
            Wait(500)
        end
    end
end)

