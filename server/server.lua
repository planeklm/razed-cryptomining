local QBCore = exports['qb-core']:GetCoreObject()
-- Per-player mining state. Replaces the global CryptoBalance/MinerStatus which
-- let any player read and write the balance of every miner on the server.
local Miners = {}
local defaultCard = 'shitgpu'

local function getData(citizenid)
    local data = MySQL.Sync.prepare('SELECT * FROM cryptominers where citizenid = ?', { citizenid })
    return data
end

local function getGPU(citizenid, card)
    local dataGPU = MySQL.Sync.prepare('SELECT * FROM cryptominers where card = ? and citizenid = ?', { card, citizenid })
    local dataCitizen = MySQL.Sync.prepare('SELECT * FROM cryptominers where citizenid = ?', { citizenid })
    return dataGPU, dataCitizen
end

RegisterNetEvent('razed-cryptomining:server:buyCryptoMiner', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if getData(Player.PlayerData.citizenid) then
        TriggerClientEvent("ox_lib:notify", src, {
            title = 'Already Owned',
            description = 'You already own a crypto miner.',
            type = 'error'
        })
        return
    end
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
        if not Player.Functions.RemoveMoney('cash', Config.Price['Stage 1'], "Bought Stage 1 Crypto Miner") then return end
        TriggerClientEvent("ox_lib:notify", src, notif1)
        TriggerClientEvent('razed-cryptomining:client:sendMail', src)
        local id = MySQL.insert('INSERT INTO `cryptominers` (citizenid, card, balance) VALUES (?, ?, ?)',
            { Player.PlayerData.citizenid, defaultCard, 0.0 })
        TriggerClientEvent('razed-cryptomining:client:addinfo', src, getData(Player.PlayerData.citizenid))
    elseif Player.PlayerData.money.bank >= Config.Price['Stage 1'] then
        TriggerClientEvent("ox_lib:notify", src, notif1)
        TriggerClientEvent('razed-cryptomining:client:sendMail', src)
        Player.Functions.RemoveMoney('bank', Config.Price['Stage 1'], "Bought Stage 1 Crypto Miner")
        local id = MySQL.insert('INSERT INTO `cryptominers` (citizenid, card, balance) VALUES (?, ?, ?)',
            { Player.PlayerData.citizenid, defaultCard, 0.0 })
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

QBCore.Functions.CreateCallback('razed-cryptomining:server:showBalance', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerCitizenID = Player.PlayerData.citizenid
    local row = MySQL.single.await('SELECT `balance` FROM `cryptominers` WHERE `citizenid` = ?', {
        Player.PlayerData.citizenid
    })
    local balance = row.balance

    cb(balance)
end)

RegisterNetEvent('razed-cryptomining:server:withdrawcrypto', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local data = getData(Player.PlayerData.citizenid)

    local row = MySQL.single.await('SELECT `balance` FROM `cryptominers` WHERE `citizenid` = ?', {
        Player.PlayerData.citizenid
    })
    local notif1 = {
        title = 'Withdrawal Failed',
        description = 'You have insuffient withdrawal funds. Keep mining!',
        duration = '500',
        type = 'error'
    }
    local notif2 = {
        title = 'Withdrawal Successfull',
        description = 'The funds have been successfully withdrew! ' ..
            row.balance .. ' coins collected, with a ' .. Config.CryptoWithdrawalFeeShown .. '% fee.',
        duration = '500',
        type = 'success'
    }

    if Config.Crypto == 'qb' then
        if row.balance > 0.001 then
            local id = MySQL.update.await('UPDATE cryptominers SET balance = ? WHERE citizenid = ?', {
                0, Player.PlayerData.citizenid
            })
            Player.Functions.AddMoney('crypto', row.balance * Config.CryptoWithdrawalFee)
            row.balance = row.balance - row.balance
            TriggerClientEvent("ox_lib:notify", src, notif2)
        else
            if row.balance < 0.001 then
                TriggerClientEvent("ox_lib:notify", src, notif1)
            else
                TriggerClientEvent("ox_lib:notify", src, notif1)
            end
        end
    else
        if Config.Crypto == 'renewed-phone' then
            if row.balance > 0.01 then
                exports['qb-phone']:AddCrypto(src, Config.RenewedCryptoType, row.balance * Config.CryptoWithdrawalFee)
                row.balance = row.balance - row.balance
                local id = MySQL.update.await('UPDATE cryptominers SET balance = ? WHERE citizenid = ?', {
                    0, Player.PlayerData.citizenid
                })
                TriggerClientEvent("ox_lib:notify", src, notif2)
            else
                if row.balance < 0.0001 then
                    TriggerClientEvent("ox_lib:notify", src, notif1)
                else
                    TriggerClientEvent("ox_lib:notify", src, notif1)
                end
            end
        end
    end
end)

RegisterNetEvent('razed-cryptomining:server:switch', function(switchStatus)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Miners[src] = switchStatus and true or false
    if not switchStatus then
        miningThreads[src] = nil -- allow the thread to be started again next toggle
    end
end)

AddEventHandler('playerDropped', function()
    Miners[source] = nil
    miningThreads[source] = nil
end)

QBCore.Functions.CreateCallback('razed-cryptomining:server:showGPU', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerCitizenID = Player.PlayerData.citizenid
    local GPUType = 'Unkown'

    if getGPU(PlayerCitizenID, 'shitgpu') then
        GPUType = "GTX 480"
    else
        if getGPU(PlayerCitizenID, '1050gpu') then
            GPUType = "GTX 1050"
        else
            if getGPU(PlayerCitizenID, '1060gpu') then
                GPUType = "GTX 1060"
            else
                if getGPU(PlayerCitizenID, '1080gpu') then
                    GPUType = "GTX 1080"
                else
                    if getGPU(PlayerCitizenID, '2080gpu') then
                        GPUType = "RTX 2080"
                    else
                        if getGPU(PlayerCitizenID, '3060gpu') then
                            GPUType = "RTX 3060"
                        else
                            if getGPU(PlayerCitizenID, '4090gpu') then
                                GPUType = "RTX 4090"
                            else
                                if getGPU(PlayerCitizenID, '5090gpu') then
                                    GPUType = "RTX 5090"
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    cb(GPUType)
end)

QBCore.Functions.CreateCallback('razed-cryptomining:server:checkGPUImage', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerCitizenID = Player.PlayerData.citizenid
    local image = 'Unkown'

    if getGPU(PlayerCitizenID, 'shitgpu') then
        image = "https://files.catbox.moe/ivxw2a.png"
    else
        if getGPU(PlayerCitizenID, '1050gpu') then
            image = "https://files.catbox.moe/rojnv7.png"
        else
            if getGPU(PlayerCitizenID, '1060gpu') then
                image = "https://files.catbox.moe/xd2c5j.png"
            else
                if getGPU(PlayerCitizenID, '1080gpu') then
                    image = "https://files.catbox.moe/y58jcq.png"
                else
                    if getGPU(PlayerCitizenID, '2080gpu') then
                        image = "https://files.catbox.moe/6ygah8.png"
                    else
                        if getGPU(PlayerCitizenID, '3060gpu') then
                            image = "https://files.catbox.moe/ugf1ir.png"
                        else
                            if getGPU(PlayerCitizenID, '4090gpu') then
                                image = "https://files.catbox.moe/4bjhmx.png"
                            else
                                if getGPU(PlayerCitizenID, '5090gpu') then
                                    image = "https://files.catbox.moe/p5odzm.png"
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    cb(image)
end)

local validGPUs = {
    ['shitgpu'] = true,
    ['1050gpu'] = true,
    ['1060gpu'] = true,
    ['1080gpu'] = true,
    ['2080gpu'] = true,
    ['3060gpu'] = true,
    ['4090gpu'] = true,
    ['5090gpu'] = true,
}

RegisterNetEvent('razed-cryptomining:server:sendGPUDatabase', function(gpu)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if gpu == nil or not validGPUs[gpu] then
        print('Attempted!')
        return
    else
        local hasItem = Player.Functions.GetItemByName(gpu)
        if not hasItem or hasItem.count < 1 then return end
        local id = MySQL.update.await('UPDATE cryptominers SET card = ? WHERE citizenid = ?', {
            gpu, Player.PlayerData.citizenid
        })
        Player.Functions.RemoveItem(gpu, 1)
        TriggerClientEvent('razed-cryptomining:client:sendGPUMail', src)
    end
end)

-- One earnings thread per player; prevents toggle-spam from spawning
-- parallel mining loops (each net event call previously started a new loop).
local miningThreads = {}

RegisterNetEvent('razed-cryptomining:server:miningSystem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local PlayerCitizenID = Player.PlayerData.citizenid
    if miningThreads[src] then return end -- already mining
    miningThreads[src] = true

    CreateThread(function()
        if getGPU(PlayerCitizenID, 'shitgpu') then
            while true do
                Wait(1000)
                while Miners[src] do
                    Wait(math.random(15000, 50000))
                    if not Miners[src] then break end
                    MySQL.update.await('UPDATE cryptominers SET balance = balance + ? WHERE citizenid = ?', {
                        math.random(1, 3) / 10, PlayerCitizenID
                    })
                    Wait(math.random(2500, 10000))
                end
            end
        else
            if getGPU(PlayerCitizenID, '1050gpu') then
                while true do
                    Wait(1000)
                    while Miners[src] do
                        Wait(math.random(12500, 40000))
                        if not Miners[src] then break end
                        MySQL.update.await('UPDATE cryptominers SET balance = balance + ? WHERE citizenid = ?',
                            {
                                math.random(2, 6) / 10, PlayerCitizenID
                            })
                        Wait(math.random(1500, 8000))
                    end
                end
            else
                if getGPU(PlayerCitizenID, '1060gpu') then
                    while true do
                        Wait(1000)
                        while Miners[src] do
                            Wait(math.random(10000, 35000))
                            if not Miners[src] then break end
                            MySQL.update.await(
                                'UPDATE cryptominers SET balance = balance + ? WHERE citizenid = ?', {
                                    math.random(3, 7) / 10, PlayerCitizenID
                                })
                            Wait(math.random(1500, 8000))
                        end
                    end
                else
                    if getGPU(PlayerCitizenID, '1080gpu') then
                        while true do
                            Wait(1000)
                            while Miners[src] do
                                Wait(math.random(8000, 30000))
                                if not Miners[src] then break end
                                MySQL.update.await(
                                    'UPDATE cryptominers SET balance = balance + ? WHERE citizenid = ?', {
                                        math.random(5, 10) / 10, PlayerCitizenID
                                    })
                                Wait(math.random(1000, 6500))
                            end
                        end
                    else
                        if getGPU(PlayerCitizenID, '2080gpu') then
                            while true do
                                Wait(1000)
                                while Miners[src] do
                                    Wait(math.random(7500, 27500))
                                    if not Miners[src] then break end
                                    MySQL.update.await(
                                        'UPDATE cryptominers SET balance = balance + ? WHERE citizenid = ?', {
                                            math.random(7, 11) / 10, PlayerCitizenID
                                        })
                                    Wait(math.random(800, 4500))
                                end
                            end
                        else
                            if getGPU(PlayerCitizenID, '3060gpu') then
                                while true do
                                    Wait(1000)
                                    while Miners[src] do
                                        Wait(math.random(5500, 20500))
                                        if not Miners[src] then break end
                                        MySQL.update.await(
                                            'UPDATE cryptominers SET balance = balance + ? WHERE citizenid = ?', {
                                                math.random(10, 15) / 10, PlayerCitizenID
                                            })
                                        Wait(math.random(600, 2500))
                                    end
                                end
                            else
                                if getGPU(PlayerCitizenID, '4090gpu') then
                                    while true do
                                        Wait(1000)
                                        while Miners[src] do
                                            Wait(math.random(2500, 18500))
                                            if not Miners[src] then break end
                                            MySQL.update.await(
                                                'UPDATE cryptominers SET balance = balance + ? WHERE citizenid = ?', {
                                                    math.random(20, 40) / 8, PlayerCitizenID
                                                })
                                            Wait(math.random(300, 1500))
                                        end
                                    end
                                end
                                if getGPU(PlayerCitizenID, '5090gpu') then
                                    while true do
                                        Wait(1000)
                                            while Miners[src] do
                                                Wait(math.random(1750, 16000))
                                                if not Miners[src] then break end
                                                MySQL.update.await(
                                                    'UPDATE cryptominers SET balance = balance + ? WHERE citizenid = ?', {
                                                        math.random(25, 50) / 6, PlayerCitizenID
                                                    })
                                                Wait(math.random(200, 1250))
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

-- for example - /sellcrypto 150 will sell 150 qbit at current price

QBCore.Commands.Add("sellcrypto", "Sell your cryptocurrency", {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Config.SellCryptoEnabled then
        TriggerClientEvent('QBCore:Notify', src, "Selling cryptocurrency is currently disabled.", "error")
        return
    end

    if Player == nil then
        TriggerClientEvent('QBCore:Notify', src, "Player not found.", "error")
        return
    end

    local coins = tonumber(args[1])
    if coins == nil or coins <= 0 then
        TriggerClientEvent('QBCore:Notify', src, "ehhh... try again with a valid amount.", "error")
        return
    end

    MySQL.Async.fetchScalar("SELECT worth FROM crypto WHERE crypto = 'qbit'", {}, function(cryptoWorth)
        if cryptoWorth and cryptoWorth > 0 then
            local playerCryptoBalance = Player.PlayerData.money.crypto or 0

            if playerCryptoBalance >= coins then
                local amount = math.floor(coins * cryptoWorth)
                Player.Functions.RemoveMoney('crypto', coins)
                Player.Functions.AddMoney('bank', amount)

                TriggerClientEvent('QBCore:Notify', src,
                    "You've sold " .. tostring(coins) .. " crypto for $" .. tostring(amount), "success")
            else
                TriggerClientEvent('QBCore:Notify', src, "You don't have enough crypto to sell.", "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "Unable to get crypto worth.", "error")
        end
    end)
end)
