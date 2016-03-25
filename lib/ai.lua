require "defines"
local util = require("lib.util")
local Unit = require("classes.Unit")
local Squad = require("classes.Squad")
local mydefines = require("lib.defines")

local ai = {}

ai.squads = {}

script.on_event(defines.events.on_player_created, function(event)
  player = game.players[event.player_index]
  ai.create_force(player.force)
end)

script.on_event(defines.events.on_force_created, function(event)
  ai.create_force(event.force)
end)

ai.create_force = function(force)
  player = force.players[1]

  if ai.squads[force.name] == nil then
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
  if index <= #game.forces then
    local force = game.forces[index]
    for name, squad in pairs(ai.squads[forcename]) do
      squad:go()
    end
  end
end

return ai
