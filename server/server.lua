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
        TriggerClientEvent('razed-cryptomining:client:sendMail', src)
        Player.Functions.RemoveMoney('cash', Config.Price['Stage 1'], "Bought Stage 1 Crypto Miner")
        local id = MySQL.insert('INSERT INTO `cryptominers` (citizenid, card, balance) VALUES (?, ?, ?)',
            { Player.PlayerData.citizenid, defaultCard, CryptoBalance  })
        TriggerClientEvent('razed-cryptomining:client:addinfo', src, getData(Player.PlayerData.citizenid))
    elseif Player.PlayerData.money.bank >= Config.Price['Stage 1'] then
        TriggerClientEvent("ox_lib:notify", src, notif1)
        TriggerClientEvent('razed-cryptomining:client:sendMail', src)
        Player.Functions.RemoveMoney('bank', Config.Price['Stage 1'], "Bought Stage 1 Crypto Miner")
        local id = MySQL.insert('INSERT INTO `cryptominers` (citizenid, card, balance) VALUES (?, ?, ?)',
        { Player.PlayerData.citizenid, defaultCard, CryptoBalance })
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
        description = 'The funds have been successfully withdrew! '..row.balance..' coins collected, with a '..Config.CryptoWithdrawalFeeShown..'% fee.',
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
    else if row.balance < 0.001 then
        TriggerClientEvent("ox_lib:notify", src, notif1)
    else
    TriggerClientEvent("ox_lib:notify", src, notif1)
    end
end
else if Config.Crypto == 'renewed-phone' then
    if row.balance > 0.01 then 
        exports['qb-phone']:AddCrypto(src, Config.RenewedCryptoType, row.balance * Config.CryptoWithdrawalFee)
        row.balance = row.balance - row.balance
        local id = MySQL.update.await('UPDATE cryptominers SET balance = ? WHERE citizenid = ?', {
            0, Player.PlayerData.citizenid
        })        TriggerClientEvent("ox_lib:notify", src, notif2)
        else if row.balance < 0.0001 then
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

QBCore.Functions.CreateCallback('razed-cryptomining:server:showGPU', function(source, cb)
local src = source
local Player = QBCore.Functions.GetPlayer(src)
local PlayerCitizenID = Player.PlayerData.citizenid
local GPUType = 'Unkown'

if getGPU(PlayerCitizenID, 'shitgpu') then
    GPUType = "GTX 480"
    else if getGPU(PlayerCitizenID, '1050gpu') then
        GPUType = "GTX 1050"
        else if getGPU(PlayerCitizenID, '1060gpu') then
            GPUType = "GTX 1060"
            else if getGPU(PlayerCitizenID, '1080gpu') then
                GPUType = "GTX 1080"
                else if getGPU(PlayerCitizenID, '2080gpu') then
                    GPUType = "RTX 2080"
                    else if getGPU(PlayerCitizenID, '3060gpu') then
                        GPUType = "RTX 3060"
                        else if getGPU(PlayerCitizenID, '4090gpu') then
                            GPUType = "RTX 4090"
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
        image = "https://i.imgur.com/UFEWLG0.png"
        else if getGPU(PlayerCitizenID, '1050gpu') then
            image = "https://i.imgur.com/Gyml2VP.png"
            else if getGPU(PlayerCitizenID, '1060gpu') then
                image = "https://i.imgur.com/O10IWVC.png"
                else if getGPU(PlayerCitizenID, '1080gpu') then
                    image = "https://i.imgur.com/gwQzyHX.png"
                    else if getGPU(PlayerCitizenID, '2080gpu') then
                        image = "https://i.imgur.com/qJ376Ca.png"
                        else if getGPU(PlayerCitizenID, '3060gpu') then
                            image = "https://i.imgur.com/OtquIm1.png"
                            else if getGPU(PlayerCitizenID, '4090gpu') then
                                image = "https://i.imgur.com/fM9V5jn.png"
                            end
                            end
                        end
                    end
                end
            end
        end
    cb(image)
end)

RegisterNetEvent('razed-cryptomining:server:sendGPUDatabase', function(gpu)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerCitizenID = Player.PlayerData.citizenid

    if gpu == nil then
        print('Attempted!')
        else
    local id = MySQL.update.await('UPDATE cryptominers SET card = ? WHERE citizenid = ?', {
        gpu, Player.PlayerData.citizenid
    })
    Player.Functions.RemoveItem(gpu, 1)
    TriggerClientEvent('razed-cryptomining:client:sendGPUMail', src)
end
end)

RegisterNetEvent('razed-cryptomining:server:miningSystem', function()
local src = source
local Player = QBCore.Functions.GetPlayer(src)
local PlayerCitizenID = Player.PlayerData.citizenid

CreateThread(function()
if getGPU(PlayerCitizenID,'shitgpu')  then
        while true do
            Wait(1000)
            while MinerStatus do
                Wait(math.random(15000, 50000))
                if MinerStatus == false then
                    break
                else if MinerStatus == true then
                CryptoBalance = CryptoBalance + math.random(1, 3) / 10
                local id = MySQL.update.await('UPDATE cryptominers SET balance = ? WHERE citizenid = ?', {
                    CryptoBalance, Player.PlayerData.citizenid
                })
                Wait(math.random(2500, 10000))
                if false then
                    break
                end
            end
        end
    end
        end
    else if getGPU(PlayerCitizenID, '1050gpu') then
                while true do
                    Wait(1000)
                    while MinerStatus do
                        Wait(math.random(12500, 40000))
                        if MinerStatus == false then
                            break
                        else if MinerStatus == true then
                        CryptoBalance = CryptoBalance + math.random(2, 6) / 10
                        local id = MySQL.update.await('UPDATE cryptominers SET balance = ? WHERE citizenid = ?', {
                            CryptoBalance, Player.PlayerData.citizenid
                        })
                        Wait(math.random(1500, 8000))
                        if false then
                            break
                        end
                    end
                end
            end
                end
            else if getGPU(PlayerCitizenID, '1060gpu') then
                    while true do
                        Wait(1000)
                        while MinerStatus do
                            Wait(math.random(10000, 35000))
                            if MinerStatus == false then
                                break
                            else if MinerStatus == true then
                            CryptoBalance = CryptoBalance + math.random(3, 7) / 10
                            local id = MySQL.update.await('UPDATE cryptominers SET balance = ? WHERE citizenid = ?', {
                                CryptoBalance, Player.PlayerData.citizenid
                            })
                            Wait(math.random(1500, 8000))
                            if false then
                                break
                            end
                        end
                    end
                end
                    end
                else if getGPU(PlayerCitizenID, '1080gpu') then
                        while true do
                            Wait(1000)
                            while MinerStatus do
                                Wait(math.random(8000, 30000))
                                if MinerStatus == false then
                                    break
                                else if MinerStatus == true then
                                CryptoBalance = CryptoBalance + math.random(5, 10) / 10
                                local id = MySQL.update.await('UPDATE cryptominers SET balance = ? WHERE citizenid = ?', {
                                    CryptoBalance, Player.PlayerData.citizenid
                                })
                                Wait(math.random(1000, 6500))
                                if false then
                                    break
                                end
                            end
                        end
                    end
                        end
                    else if getGPU(PlayerCitizenID, '2080gpu') then
                            while true do
                                Wait(1000)
                                while MinerStatus do
                                    Wait(math.random(7500, 27500))
                                    if MinerStatus == false then
                                        break
                                    else if MinerStatus == true then
                                    CryptoBalance = CryptoBalance + math.random(7, 11) / 10
                                    local id = MySQL.update.await('UPDATE cryptominers SET balance = ? WHERE citizenid = ?', {
                                        CryptoBalance, Player.PlayerData.citizenid
                                    })
                                    Wait(math.random(800, 4500))
                                    if false then
                                        break
                                    end
                                end
                            end
                                end
                            end
                    else if getGPU(PlayerCitizenID, '3060gpu') then
                            while true do
                                Wait(1000)
                                while MinerStatus do
                                    Wait(math.random(5500, 20500))
                                    if MinerStatus == false then
                                        break
                                    else if MinerStatus == true then
                                    CryptoBalance = CryptoBalance + math.random(10, 15) / 10
                                    local id = MySQL.update.await('UPDATE cryptominers SET balance = ? WHERE citizenid = ?', {
                                        CryptoBalance, Player.PlayerData.citizenid
                                    })
                                    Wait(math.random(600, 2500))
                                    if false then
                                        break
                                    end
                                end
                            end
                                end
                            end
                else if getGPU(PlayerCitizenID, '4090gpu') then
                        while true do
                            Wait(1000)
                            while MinerStatus do
                                Wait(math.random(2500, 18500))
                                if MinerStatus == false then
                                    break
                                else if MinerStatus == true then
                                CryptoBalance = CryptoBalance + math.random(20, 40) / 8
                                local id = MySQL.update.await('UPDATE cryptominers SET balance = ? WHERE citizenid = ?', {
                                    CryptoBalance, Player.PlayerData.citizenid
                                })
                                Wait(math.random(300, 1500))
                                if false then
                                    break
                                end
                            end
                        end
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

                TriggerClientEvent('QBCore:Notify', src, "You've sold " .. tostring(coins) .. " crypto for $" .. tostring(amount), "success")
            else
                TriggerClientEvent('QBCore:Notify', src, "You don't have enough crypto to sell.", "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "Unable to get crypto worth.", "error")
        end
    end)
end)
