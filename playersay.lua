if PlayerSay == nil then
  print ( '[PlayerSay] creating PlayerSay' )
  PlayerSay = {}
  PlayerSay.__index = PlayerSay

  PlayerSay.teamChatCallback = nil;
  PlayerSay.allChatCallback = nil;
  
  Convars:RegisterCommand('player_say', function(...)
    local arg = {...}
    table.remove(arg,1)
    local sayType = tonumber(arg[1])
    table.remove(arg,1)

    local cmdPlayer = Convars:GetCommandClient()
    local text = table.concat(arg, " ")

    if (sayType == 4) then
      -- Student messages
    elseif (sayType == 3) then
      -- Coach messages
    elseif (sayType == 2) and PlayerSay.teamChatCallback then
      local status, ret = pcall(PlayerSay.teamChatCallback, cmdPlayer, text)
      if not status then
        print('[PlayerSay] TeamChat callback failure: ' .. ret)
      end
    elseif PlayerSay.allChatCallback then
      local status, ret = pcall(PlayerSay.allChatCallback, cmdPlayer, text)
      if not status then
        print('[PlayerSay] AllChat callback failure: ' .. ret)
      end
    end

    
  end, 'player say', 0)
end



function PlayerSay:TeamChatHandler(fun)
  PlayerSay.teamChatCallback = fun
end
function PlayerSay:AllChatHandler(fun)
  PlayerSay.allChatCallback = fun
end

function PlayerSay:SendConfigToAll(allowTeam, allowAll)
  PlayerSay:SendConfig(-1, allowTeam, allowAll)
end
function PlayerSay:SendConfig(pid, allowTeam, allowAll)
  local obj = {pid=pid, allowTeam=allowTeam, allowAll=allowAll}
  FireGameEvent("player_say_config", obj)
end