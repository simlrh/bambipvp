local util = require("lib.util")
local mydefines = require("lib.defines")
require "defines"

local Squad = util.class()
Squad.mt = {
  __index = function(table, index)
    if Squad[index] then
      return Squad[index]
    end
    if (table.unit_group ~= nil) then
      if table.unit_group[index] then
        return table.unit_group[index]
      end
    end
  end
}

Squad.RADIUS = 5.0
Squad.FOLLOW_RADIUS = 7.5
Squad.DISTRACTION_RADIUS = 15
Squad.DISTRACTION = defines.distraction.by_enemy

function Squad:_init(force, position)
  player = force.players[1]

  if not position then
    position = player.position
  end

  self.player = player
  self.force = force

  self.members = {}

  self.unit_group = player.surface.create_unit_group({position=position})
  setmetatable(self, Squad.mt)
  self.last_position = position

  self.command = mydefines.ai.command_type.idle
  self.followee = nil
end

function Squad:validate() 
  if not self.valid then
    self.unit_group = player.surface.create_unit_group({position=self.last_position})
    setmetatable(self, Squad.mt)

    for k, unit in pairs(self.members) do
      if unit.valid then
        self.unit_group.add_member(unit.entity)
      else 
        table.remove(self.members, k)
      end
    end
  end
end

function Squad:add_member(unit)
  self:validate()

  unit.squad = self
  table.insert(self.members,unit)
  self.unit_group.add_member(unit.entity)
end

function Squad:remove_member(unit)
  self:validate()

  for k, u in pairs(self.members) do
    if u == unit then
      table.remove(self.members, k)
    end
  end
  self.unit_group.add_member(unit.entity)
end

function Squad:set_command(command)
  if util.in_array(command.command, mydefines.ai.command_type) then
    self.command = command.command
  end

  if (self.command == mydefines.ai.command_type.follow) then
    self.followee = command.entity
  end
end

function Squad:idleBehavior()
  if util.pyDistance(self.followee.position, self.unit_group.position) > Squad.FOLLOW_RADIUS then
    self:moveToFollowee()
  end
end

function Squad:moveToFollowee()
  self:validate()
  self.unit_group.set_command({type=defines.command.go_to_location, destination=self.followee.position, radius=Squad.RADIUS, distraction=Squad.DISTRACTION})
  self.unit_group.start_moving()
end 

function Squad:go()
  self:validate()

  local idle_states = {defines.groupstate.gathering, defines.groupstate.finished}
  local moving_states = {defines.groupstate.moving}
  local attack_states = {defines.groupstate.attacking_distraction, defines.groupstate.attacking_target}
  local state = self.unit_group.state

  if (self.command == mydefines.ai.command_type.idle) then
    if not util.in_array(state, idle_states) and not util.in_array(state, attack_states) then
      self.unit_group.set_command({type=defines.command.wander, distraction=Squad.DISTRACTION})
    end
  end

  if (self.command == mydefines.ai.command_type.follow) then
    local distance = util.pyDistance(self.followee.position, self.unit_group.position)
    if util.in_array(state, attack_states) then
      if distance > Squad.DISTRACTION_RADIUS then self:moveToFollowee() end
    else
      if distance > Squad.FOLLOW_RADIUS then self:moveToFollowee() end
    end
  end

  self.last_position = self.unit_group.position
end

function Squad:destroy()
  self.unit_group.destroy()
end

return Squad
