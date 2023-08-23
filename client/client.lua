local QBCore = exports['qb-core']:GetCoreObject()
local CryptoMinerProp = Config.CryptoMinerProp
local CryptoBalance = 0.0
local MinerStatus = false

local arg = {
    owned = false
}

RegisterNetEvent('razed-cryptomining:client:CryptoMiningMenu', function()
    lib.registerContext({
        id = 'cryptomenuon',
        title = 'Crypto Miner Menu',
        options = {
            {
                title = 'Toggle, View the Status or Withdraw.',
              },
            {
                title = 'Toggle Crypto Miner',
                description = 'This toggles the crypto miner to start or stop.',
                icon = 'toggle-on',
                onSelect = function()
                    ToggleCryptoMiner()
                    if MinerStatus == true then
                        lib.showContext('cryptomenuon')
                    else
                        lib.showContext('cryptomenuoff')
                    end
                end,
            },
            {
                title = 'Miner Status - 🟢',
                description = 'Hover over this button to show the status of the miner.',
                icon = 'question',
                image = 'https://i.imgur.com/KiBDJuX.png'
            }
      }}
    )
    lib.registerContext({
        id = 'cryptomenuoff',
        title = 'Crypto Miner Menu',
        options = {
            {
                title = 'Toggle, View the Status or Withdraw.',
              },
            {
                title = 'Toggle Crypto Miner',
                description = 'This toggles the crypto miner to start or stop.',
                icon = 'toggle-off',
                onSelect = function()
                    ToggleCryptoMiner()
                    if MinerStatus == true then
                        lib.showContext('cryptomenuon')
                    else
                        lib.showContext('cryptomenuoff')
                    end
                end,
            },
            {
                title = 'Miner Status - 🔴',
                description = 'Hover over this button to show the status of the miner.',
                icon = 'question',
                image = 'https://i.imgur.com/RWNejJy.png'
            },
            {
                title = 'Withdraw',
                description = 'Withdraw your crypto: '..Config.CryptoWithdrawalFeeShown.. '% Fee',
                icon = 'dollar',
                serverEvent = 'razed-cryptomining:server:withdrawcrypto',
                image = 'https://i.imgur.com/UJGPHfe.png'
            }
      }}
    )

    if MinerStatus == true then
        lib.showContext('cryptomenuon')
    else
        lib.showContext('cryptomenuoff')
    end
end)




RegisterNetEvent('razed-cryptomining:client:BuyCryptoMining', function(args)
    lib.registerContext({
        id = 'buycryptominer',
        title = 'Purchase Crypto Miner',
        options = {
            {
                title = 'Purchase or use the Crypto Miner.',
              },
            {
                title = 'Purchase',
                description = 'Price: $'..Config.Price['Stage 1'],
                icon = 'dollar',
                serverEvent = 'razed-cryptomining:server:buyCryptoMiner',
                disabled = args.owned,
                metadata = {
                  {label = 'Reviews:', value = '⭐⭐⭐⭐⭐/5'}
                },
            },
            {
                title = 'Proceed To Crypto Miner Menu',
                description = 'If you click this button, it will locate you to the main user interface for the crypto miner.',
                icon = 'fa-brands fa-bitcoin',
                event = 'razed-cryptomining:client:CryptoMiningMenu',
                disabled = not args.owned
            }
      }}
    )
    lib.showContext('buycryptominer')
end)

function ToggleCryptoMiner()
 if MinerStatus == true then
        lib.notify({
            title = 'Stopping Miner!',
            description = 'The miner has been stopped and now will stop mining coins.',
            type = 'error',
            duration = '500'
        })
        Wait(500)
            MinerStatus = false
            print('Stopped Miner')
        MinerStopped()
    else if MinerStatus == false then
        lib.notify({
            title = 'Starting Miner!',
            description = 'The miner has been started and now will start mining coins!',
            type = 'success',
            duration = '500'
        })
        Wait(500)
            MinerStatus = true
            print('Starting Miner')
        MinerStarted()
    end
  end
end

RegisterNetEvent('razed-cryptomining:client:addinfo', function(data)
    if data == nil then
        arg.owned = false
    else
        arg.owned = true
    end
end)

function MinerStarted()
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'progressbar', 0.5)
    TriggerServerEvent('razed-cryptomining:server:switch', true)
end

function MinerStopped()
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'progressbarcancel', 0.5)
    TriggerServerEvent('razed-cryptomining:server:switch', false)
end

RegisterNetEvent('razed-cryptomining:client:CheckIfOwnedCrypto', function()
    TriggerServerEvent('razed-cryptomining:server:getinfo')
    Wait(1000)
    TriggerEvent('razed-cryptomining:client:BuyCryptoMining', arg)
end)



CreateThread(function()
    if Config.Target == 'qb' then
    exports['qb-target']:AddTargetModel(CryptoMinerProp, {
        options = {
            { 
                icon = "fa-brands fa-bitcoin",
                label = "Open Crypto Miner Menu",
                event = "razed-cryptomining:client:CheckIfOwnedCrypto"
            },
          },
          distance = 3.0,
    })
else if Config.Target == 'ox' then
    exports.ox_target:addModel(CryptoMinerProp, {
        options = {
            {
                icon = "fa-brands fa-bitcoin",
                label = "Open Crypto Miner Menu",
                event = "razed-cryptomining:client:CheckIfOwnedCrypto"
            },
        },
        distance = 3.0,
    })
    end
  end
end)
