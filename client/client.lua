local QBCore = exports['qb-core']:GetCoreObject()
local CryptoMinerProp = Config.CryptoMinerProp
local MinerStatus = false
local arg = {
    owned = false
}

RegisterNetEvent('CryptoMiningMenu', function()
    lib.registerContext({
        id = 'cryptomenuon',
        title = 'Crypto Miner Menu',
        options = {
            {
                title = 'Toggle Crypto Miner',
                description = 'This toggles the crypto miner to start or stop.',
                icon = 'toggle-on',
                onSelect = function()
                    ToggleCryptoMiner()
                end,
            },
            {
                title = 'Miner Status - 🟢',
                description = 'Hover over this button to show the status of the miner.',
                icon = 'question',
                metadata = {
                  {label = 'Miner Status', value = MinerStatus}
                },
            }
      }}
    )
    lib.registerContext({
        id = 'cryptomenuoff',
        title = 'Crypto Miner Menu',
        options = {
            {
                title = 'Toggle Crypto Miner',
                description = 'This toggles the crypto miner to start or stop.',
                icon = 'toggle-off',
                onSelect = function()
                    ToggleCryptoMiner()
                end,
                --metadata = {
                --  {label = 'Miner Status', value = MinerStatus}
                --},
            },
            {
                title = 'Miner Status - 🔴',
                description = 'Hover over this button to show the status of the miner.',
                icon = 'question',
                metadata = {
                  {label = 'Miner Status', value = MinerStatus}
                },
            },
            {
                title = 'Withdraw',
                description = 'Withdraw your crypto: '..Config.CryptoWithdrawalFee.. '% Fee',
                icon = 'dollar',
                onSelect = function()
                    
                end,
                metadata = {
                  {label = 'Withdraw Availability', value = '🟢'}
                },
            }
      }}
    )

    if MinerStatus == true then
        lib.showContext('cryptomenuon')
    else
        lib.showContext('cryptomenuoff')
    end
end)

RegisterNetEvent('BuyCryptoMining', function(args)
    lib.registerContext({
        id = 'buycryptominer',
        title = 'Purchase Crypto Miner',
        options = {
            {
                title = 'Purchase',
                description = 'Price: '..Config.Price['Stage 1'],
                icon = 'dollar',
                serverEvent = 'razed-cryptomining:buyCryptoMiner',
                disabled = args.owned,
                metadata = {
                  {label = 'Reviews:', value = '⭐⭐⭐⭐⭐/5'},
                  {label = 'Pong Slug - ', value = 'Very good crypto miner it is pretty good I reccomend it ⛏.'},
                  {label = 'Dogeman - ', value = 'Doge to moon pls 🐶.'}
                },
            },
            {
                title = 'Proceed To Crypto Miner Menu',
                description = 'If you click this button, it will locate you to the main user interface for the crypto miner.',
                icon = 'fa-brands fa-bitcoin',
                event = 'CryptoMiningMenu',
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
            type = 'error',
            duration = 1000
        })
            MinerStatus = false
            print('Stopped Miner')
        MinerStopped()
    else if MinerStatus == false then
        lib.notify({
            title = 'Starting Miner!',
            type = 'success',
            duration = 1000
        })
            MinerStatus = true
            print('Starting Miner')
        MinerStarted()
    end
  end
end

RegisterNetEvent('razed-cryptomining:client:addinfo', function(data)
    if data == nil then
        arg.owned = false
        CLUB_OWNED = false
    else
        arg.owned = true
        CLUB_OWNED =  true
    end
end)

function MinerStarted()
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'progressbar', 1.0)
end

function MinerStopped()
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'progressbarcancel', 1.0)

end

RegisterNetEvent('CheckIfOwnedCrypto', function()
    TriggerServerEvent('razed-cryptomining:server:getinfo')
    Wait(1000)
    TriggerEvent('BuyCryptoMining', arg)
end)

CreateThread(function()
    if Config.Target == 'qb' then
    exports['qb-target']:AddTargetModel(CryptoMinerProp, {
        options = {
            { 
                icon = "fa-brands fa-bitcoin",
                label = "Open Crypto Miner Menu",
                event = "CheckIfOwnedCrypto"
            },
          },
          distance = 3,
    })
else if Config.Target == 'ox' then
    exports.ox_target:addModel(CryptoMinerProp, {
        options = {
            {
                icon = "fa-brands fa-bitcoin",
                label = "Open Crypto Miner Menu",
                event = "CheckIfOwnedCrypto"
            },
        },
        distance = 3,
    })
    end
  end
end)
