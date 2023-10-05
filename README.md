![RazedCryptoMining23](https://github.com/planeklm/razed-cryptomining/assets/91488137/2974fd19-33f9-409a-a1a1-194d1590237c)

**Hello FiveM community!👋**\
We have created an crypto mining system for the qbcore framework. The overall idea for this script is that I have yet to find a free crypto miner which functions. Thank you to everybody who contributed to this project, I am very proud of what we have created!

# Features
* **7 graphics card upgrades** - If your players are needing an upgrade, they can choose 7 different tiers of graphics cards, from the GTS 480 to the RTS 4090.
* **Withdraw crypto with a set fee** - When the coins are withdrew, you can set a fee (default 10%).
*  **Crypto miner in houses** - With different housing scripts, you can place down the server rack prop to use the miner.
* **Lightweight and optimized** - We've tried to make the most lightweight and optimized script, this means it can run on virtually any server without sacrificing preformance.
* **Fully open-source & customizable** - Want to add more graphics cards? Or help us expand this script? We've made our script in the main idea of community collabration. Not sure what to do? We've made our config file with as many options to suit your server.
* **Configurable prices, props, fees and emails**

# Preview
[![](https://i.imgur.com/USdx6mP.png)](https://youtu.be/ohPHNCPLdt4)

# Installation
* Drag and drop `razed-cryptomining`
* In your `server.cfg` add `ensure razed-cryptomining`
* Execute the `cryptomining.sql` into your database

# Recomendations From Us
* If using `ps-housing` or `qb-housing`, we reccomend to change the price of the server rack prop to the appropriate price of a mining rig. You can use the server rack prop as a mining rig for houses or warehouses!

# Items & Images
**❤️ to Markow (amsali22) for making this!**\
[razed-crypto-imgs](https://github.com/amsali22/razed-crypto-imgs)

* Drag and Drop the `images` to your inventory `images` folder.

* Add This to your `qb-core/shared/items.lua` For items to work.

```

	["shitgpu"] 				    = {["name"] = "shitgpu", 			 	  	["label"] = "A trash gpu",            ["weight"] = 0, 		["type"] = "item", 		["image"] = "shitgpu.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Just look at it, what do you expect!"},

	["1050gpu"] 				    = {["name"] = "1050gpu", 			 	  	["label"] = "gtx 1050",            ["weight"] = 0, 		["type"] = "item", 		["image"] = "1050.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "It does the job for its price."},

	["1060gpu"] 				    = {["name"] = "1060gpu", 			 	  	["label"] = "gtx 1060",            ["weight"] = 0, 		["type"] = "item", 		["image"] = "1060.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "A good upgrade if you are broke."},

	["1080gpu"] 				    = {["name"] = "1080gpu", 			 	  	["label"] = "gtx 1080",            ["weight"] = 0, 		["type"] = "item", 		["image"] = "1080.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "It must be good since it got 3 fans right?"},

	["2080gpu"] 				    = {["name"] = "2080gpu", 			 	  	["label"] = "RTX 2080",            ["weight"] = 0, 		["type"] = "item", 		["image"] = "2080.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "WOOW!! A new look! Then This is the one."},

	["3060gpu"] 				    = {["name"] = "3060gpu", 			 	  	["label"] = "RTX 3060",            ["weight"] = 0, 		["type"] = "item", 		["image"] = "3060.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "IDK Man! It's so expensive."},

	["4090gpu"] 				    = {["name"] = "4090gpu", 			 	  	["label"] = "RTX 4090",            ["weight"] = 0, 		["type"] = "item", 		["image"] = "4090.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Is it just me or this looks kinda thicc?"},

	["thermalpast"] 				    = {["name"] = "thermalpast", 			 	  	["label"] = "Thermal past",            ["weight"] = 0, 		["type"] = "item", 		["image"] = "thermalpast.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "A thermalpast To keep your cpu chiling."},

```

# Dependencies
[qb-core](https://github.com/qbcore-framework/qb-core)\
[interact-sound](https://github.com/qbcore-framework/interact-sound)\
[ox_lib](https://github.com/overextended/ox_lib)\
[oxmysql](https://github.com/overextended/oxmysql)

[qb-crypto](https://github.com/qbcore-framework/qb-crypto)\
**or**\
[renewed-phone](https://github.com/Renewed-Scripts/qb-phone) - Make sure to configure your settings in config.lua

[qb-target](https://github.com/qbcore-framework/qb-target)\
**or**\
[ox_target](https://github.com/overextended/ox_target)

# Optionals
[renewed-phone](https://github.com/Renewed-Scripts/qb-phone)

# Script Optimization Preview
![imagffffe](https://github.com/planeklm/razed-cryptomining/assets/91488137/ae69a460-e370-47e1-88ab-eef19a4e1e61)


# Credits
[planeklm (KLM)](https://github.com/planeklm)\
[LeSiiN](https://github.com/LeSiiN)\
[Markow](https://github.com/amsali22)
