Config = {}

Config.CryptoMinerProp = {
    `prop_laptop_01a`, -- Example
    `v_corp_servercln`
}

-- If one of these have been changed, you must change both to not confuse players.
Config.CryptoWithdrawalFeeShown = '10' -- This is a percentage shown the the ox_lib menu - e.g 10 = 10%
Config.CryptoWithdrawalFee = '0.90' -- This is a percentage of the fee when withdrawing the crypto - e.g 0.90 = 10%

Config.Target = 'qb' -- 'qb' or 'ox' depending on the target you use

Config.Crypto = 'qb' -- 'qb' or 'renewed-phone' depending on the crypto resource you use
Config.RenewedCryptoType = "gne" -- "gne" or "shung" or "xcoin" or "lme" - only change if using renewed phone

Config.Price = {
    ['Stage 1'] = 85000, -- Price to buy the crypto miner
}
