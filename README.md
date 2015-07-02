# PlayerSay Module

## Introduction
PlayerSay is a scaleform module for dota 2 custom games which allows for processing chat statements by clients through the server.  It also allows for you to deny/enable team chat AND/OR all chat to individual players dynamically throughout your game.
**PlayerSay is SCALEFORM, which means at some point in the near future it will no longer work.  If you base your game round amount chat commands as a necessity, you are putting yourself at risk.**

## Installation
- Download this git repository.
- Install PlayerSay.swf to your game/dota_addons/ADDON/resource/flash3 folder 
- Merge the custom_ui.txt file from this repo with your own in game/dota_addons/ADDON/resource/flash3 so that the resulting custom_ui.txt file contains a block for "PlayerSay".  If you do not have a version of this file you can use the provided file by itself.
- Merge the custom_events.txt file from this repo with your own in game/dota_addons/ADDON/scripts so that the resulting custom_events.txt file contains a block for "player_say_config".  If you do not have a version of this file you can use the provided file by itself.
- Add playersay.lua to your game/dota_addons/ADDON/scripts/vscripts directory (or some subdirectory) and make sure that you add require('playersay') to your addon_game_mode.lua or similar file.

## Usage
In order to listen for player chat, you need to register a handler function for Team chat, and another for All chat:
    PlayerSay:TeamChatHandler(function(playerEntity, text)
      print(playerEntity:GetPlayerID() .. " said '" .. text .. '" to their team.')
    end)

    PlayerSay:AllChatHandler(function(playerEntity, text)
      print(playerEntity:GetPlayerID() .. " said '" .. text .. '" to all chat.')
    end)

You can use these handlers to parse the given text, or do whatever you like with it.

By default, all clients are allowed to send chat messages on both Team/Ally chat and All chat.  To adjust this at any point in the game, call:
    PlayerSay:SendConfig(playerID, allowTeamChatBoolean, allowAllChatBoolean)
e.g.
    PlayerSay:SendConfig(0, false, false)
will prevent the player with ID 0 from sending any messages to both Team/Ally chat and All chat.  To turn back on all chat only, you could call:
    PlayerSay:SendConfig(0, false, true)

Additionally, you can change the configuration of all clients at once using the following command:
    PlayerSay:SendConfigToAll(false, false)

SendConfig and SendConfigToAll only disable the normal team/all chat behavior of sending messages to other players, but you can still work with the messages sent to the serve in the TeamChatHandler and AllChatHandler functions.