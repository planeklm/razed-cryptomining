local QBCore = exports['qb-core']:GetCoreObject()
local CryptoMinerProp = Config.CryptoMinerProp
local CryptoBalance = 0.0
local MinerStatus = false

local arg = {
    owned = false
}

RegisterNetEvent('razed-cryptomining:client:CryptoMiningMenu', function()
    QBCore.Functions.TriggerCallback('razed-cryptomining:server:showBalance', function(balance)
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
                image = 'https://files.catbox.moe/d7r1x0.png'
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
                title = 'Balance: '..balance,
                icon = 'fa-brands fa-bitcoin'
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
                image = 'https://files.catbox.moe/q3iz9v.png'
            },
            {
                title = 'Withdraw',
                description = 'Withdraw your crypto: '..Config.CryptoWithdrawalFeeShown.. '% Fee',
                icon = 'dollar',
                serverEvent = 'razed-cryptomining:server:withdrawcrypto',
                image = 'https://files.catbox.moe/8wh7y4.png'
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
                description = 'The default gpu. Lets just say its a classic...',
                icon = 'fa-solid fa-question',
                event = 'razed-cryptomining:client:useGTX480',
                image = 'https://files.catbox.moe/ivxw2a.png',
                disabled = CheckGTX480()
            },
            {
                title = 'GTX 1050',
                description = 'The 1050. It is alright, but very slow.',
                icon = 'fa-solid fa-1',
                event = 'razed-cryptomining:client:useGTX1050',
                image = 'https://files.catbox.moe/rojnv7.png',
                disabled = CheckGTX1050()
            },
            {
                title = 'GTX 1060',
                description = 'The 1060. Are we stil in 2018?',
                icon = 'fa-solid fa-2',
                event = 'razed-cryptomining:client:useGTX1060',
                image = 'https://files.catbox.moe/xd2c5j.png',
                disabled = CheckGTX1060()
            },
            {
                title = 'GTX 1080',
                description = 'An absolute classic!',
                icon = 'fa-solid fa-3',
                event = 'razed-cryptomining:client:useGTX1080',
                image = 'https://files.catbox.moe/y58jcq.png',
                disabled = CheckGTX1080()
            },
            {
                title = 'RTX 2080',
                description = 'The first raytracing flagship.',
                icon = 'fa-solid fa-4',
                event = 'razed-cryptomining:client:useRTX2080',
                image = 'https://files.catbox.moe/6ygah8.png',
                disabled = CheckRTX2080()
            },
            {
                title = 'RTX 3060',
                description = 'Was the best gpu for price to preformance, but it is pretty slow now-a-days.',
                icon = 'fa-solid fa-5',
                event = 'razed-cryptomining:client:useRTX3060',
                image = 'https://files.catbox.moe/ugf1ir.png',
                disabled = CheckRTX3060()
            },
            {
                title = 'RTX 4090',
                description = 'An absolute beast of a card, will you really need to upgrade it?',
                icon = 'fa-solid fa-6',
                event = 'razed-cryptomining:client:useRTX4090',
                image = 'https://files.catbox.moe/4bjhmx.png',
                disabled = CheckRTX4090()
            },
            {
                title = 'RTX 5090',
                description = 'The best of the best. An absolute tank, no need for another upgrade.',
                icon = 'fa-solid fa-7',
                event = 'razed-cryptomining:client:useRTX5090',
                image = 'https://files.catbox.moe/p5odzm.png',
                disabled = CheckRTX5090()
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
    if Config.Email == true then
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = Config.PurchaseEmailSender,
        subject = Config.PurchaseEmailSubject,
        message = Config.PurchaseEmailText,
    })
    else if Config.Email == false then
        print('Bought Miner')
    end
end
end)

RegisterNetEvent('razed-cryptomining:client:sendGPUMail', function()
    if Config.Email == true then
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = Config.gpuEmailSender,
        subject = Config.gpuEmailSubject,
        message = Config.gpuEmailText,
    })
    else if Config.Email == false then
        print('Bought Miner')
    end
end
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
