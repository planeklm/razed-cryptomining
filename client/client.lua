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
            },
            {
                title = 'Go Back',
                description = 'Go back to the main menu.',
                icon = 'arrow-left',
                event = 'razed-cryptomining:client:CheckIfOwnedCrypto'
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
            },
            {
                title = 'Go Back',
                description = 'Go back to the main menu.',
                icon = 'arrow-left',
                event = 'razed-cryptomining:client:CheckIfOwnedCrypto'
            },
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
                title = 'Purchase, Upgrade or use the Crypto Miner.',
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
            },
            {
                title = 'Upgrade Mining Rig',
                description = 'If you click this button, it will locate you to the upgrade menu.',
                icon = 'fa-solid fa-sim-card',
                event = 'razed-cryptomining:client:UpgradeCryptoMining',
                disabled = not args.owned
            }
      }}
    )
    lib.showContext('buycryptominer')
end)

RegisterNetEvent('razed-cryptomining:client:UpgradeCryptoMining', function()
    QBCore.Functions.TriggerCallback('razed-cryptomining:server:showGPU', function(GPUType)
    QBCore.Functions.TriggerCallback('razed-cryptomining:server:checkGPUImage', function(image)

    lib.registerContext({
        id = 'upgradecryptominer',
        title = 'Upgrade Crypto Miner',
        options = {
            {
                title = 'Got the GPU? Upgrade it here!',
            },
            {
                title = 'Current GPU: '..GPUType,
                image = image
            },
            {
                title = 'Go Back',
                description = 'Go back to the main menu.',
                icon = 'arrow-left',
                event = 'razed-cryptomining:client:CheckIfOwnedCrypto'
            },
            {
                title = 'GTX 480',
                description = 'The default gpu... We will just say its a classic...',
                icon = 'fa-solid fa-question',
                event = 'razed-cryptomining:client:useGTX480',
                image = 'https://i.imgur.com/UFEWLG0.png',
                disabled = CheckGTX480()
            },
            {
                title = 'GTX 1050',
                description = 'The second gpu. It is alright, but still quite slow.',
                icon = 'fa-solid fa-1',
                event = 'razed-cryptomining:client:useGTX1050',
                image = 'https://i.imgur.com/Gyml2VP.png',
                disabled = CheckGTX1050()
            },
            {
                title = 'GTX 1060',
                description = 'The third gpu. Its +10 from the last so it has to be good right?',
                icon = 'fa-solid fa-2',
                event = 'razed-cryptomining:client:useGTX1060',
                image = 'https://i.imgur.com/O10IWVC.png',
                disabled = CheckGTX1060()
            },
            {
                title = 'GTX 1080',
                description = 'The fourth best gpu. An absolute classic!',
                icon = 'fa-solid fa-3',
                event = 'razed-cryptomining:client:useGTX1080',
                image = 'https://i.imgur.com/gwQzyHX.png',
                disabled = CheckGTX1080()
            },
            {
                title = 'RTX 2080',
                description = 'The 3nd best gpu. Was good a few years ago, but still great.',
                icon = 'fa-solid fa-4',
                event = 'razed-cryptomining:client:useRTX2080',
                image = 'https://i.imgur.com/qJ376Ca.png',
                disabled = CheckRTX2080()
            },
            {
                title = 'RTX 3060',
                description = 'The 2nd best gpu. The best gpu for price to preformance, but still not the best.',
                icon = 'fa-solid fa-5',
                event = 'razed-cryptomining:client:useRTX3060',
                image = 'https://i.imgur.com/OtquIm1.png',
                disabled = CheckRTX3060()
            },
            {
                title = 'RTX 4090',
                description = 'The best of the best. An absolute tank, no need for another upgrade.',
                icon = 'fa-solid fa-6',
                event = 'razed-cryptomining:client:useRTX4090',
                image = 'https://i.imgur.com/fM9V5jn.png',
                disabled = CheckRTX4090()
            }
      }}
    )
    lib.showContext('upgradecryptominer')
end)
end)
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
    TriggerServerEvent('razed-cryptomining:server:miningSystem')
end

function MinerStopped()
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'progressbarcancel', 0.5)
    TriggerServerEvent('razed-cryptomining:server:switch', false)
end

RegisterNetEvent('razed-cryptomining:client:CheckIfOwnedCrypto', function()
    TriggerServerEvent('razed-cryptomining:server:getinfo')
    Wait(500)
    TriggerEvent('razed-cryptomining:client:BuyCryptoMining', arg)
end)

RegisterNetEvent('razed-cryptomining:client:sendMail', function()
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = Config.PurchaseEmailSender,
        subject = Config.PurchaseEmailSubject,
        message = Config.PurchaseEmailText,
    })
end)

RegisterNetEvent('razed-cryptomining:client:sendGPUMail', function()
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = Config.gpuEmailSender,
        subject = Config.gpuEmailSubject,
        message = Config.gpuEmailText,
    })
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
