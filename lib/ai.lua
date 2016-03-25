require "defines"
local util = require("lib.util")
local Unit = require("classes.Unit")
local Squad = require("classes.Squad")
local mydefines = require("lib.defines")

local ai = {
  squads = {}
}

script.on_event(defines.events.on_player_created, function(event)
  player = game.players[event.player_index]
  ai.create_force(player.force)
end)

script.on_event(defines.events.on_force_created, function(event)
  ai.create_force(event.force)
end)

ai.create_force = function(force)
  player = force.players[1]

  if ai.squads[force.name] == nil and player ~= nil then
    ai.squads[force.name] = {
      unassigned = Squad(force)
    }
    ai.squads[force.name].unassigned:set_command({command=mydefines.ai.command_type.follow, entity=player.character})
  end
end

script.on_event(defines.events.on_built_entity, function(event)
  if util.in_array(event.created_entity.name, mydefines.units) then
    ai.init_unit(event.created_entity, game.players[event.player_index])
  end
end)

script.on_event(defines.events.on_preplayer_mined_item, function(event)
  if util.in_array(event.entity.name, mydefines.units) then
    Unit.remove(event.entity)
  end
end)

script.on_event(defines.events.on_entity_died, function(event)
  if util.in_array(event.entity.name, mydefines.units) then
    Unit.remove(event.entity)
  end
end)

ai.init_unit = function(entity, player)
  force = player.force
  local squad = ai.squads[force.name].unassigned

  local unit = Unit(entity)
  squad:add_member(unit)
end

ai.go = function()
end

ai.tick = function() 
  local index = (game.tick % math.max(15, #game.forces)) + 1

  local i = 0
  for name, squads in pairs(ai.squads) do
    i = i + 1
    if i == index then
      for name, squad in pairs(squads) do
        squad:go()
      end
    end
  end
  if force ~= nil then
    for name, squad in pairs(ai.squads[force.name]) do
      squad:go()
    end
  end
end

return ai
