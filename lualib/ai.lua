require "bambiutil"

command_type =
{
  idle = 1,
  wander = 2,
  follow = 3,
  attack = 4
}

Squad = bambiutil.class(function(squad, player, position)
  if not position then
    position = player.position
  end

  squad.unit_group = player.surface.create_unit_group({position=position})
  squad.__index = squad.unit_group

  squad.command = command_type.idle

end)

function Squad:validate() 
  if not self.valid then
    self.unit_group = player.surface.create_unit_group({position=player.position})
    self.__index = self.unit_group
  end
end

function Squad:add_member(entity)
  self.validate()
end

function Squad:set_command(command)
  self.validate()

  if command == command_type.follow then
  else if false then
  end
end

global.unit_groups = {}

script.on_event(defines.events.on_player_created, function(event)
  global.unit_groups[event.player_index] = {
    unassigned = Squad(game.players[event.player_index])
  }
end

init_unit = function(entity)
  local idle_group = global.unit_groups[game.player.index].unassigned
  if not idle_group.valid then
    idle_group = game.player.surface.create_unit_group({position=game.player.position})
  end
  idle_group.add_member(entity)
  entity.insert({name="basic-bullet-magazine", count=10})
  entity.insert({name="car", count=1})
end
