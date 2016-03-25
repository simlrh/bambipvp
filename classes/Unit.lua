local util = require("lib.util")
local mydefines = require("lib.defines")

require "defines"

local Unit = util.class()
Unit.mt = {
  __index = function(table, index)
    if Unit[index] then
      return Unit[index]
    end
    if (table.entity ~= nil) then
      if table.entity[index] then
        return table.entity[index]
      end
    end
  end
}

Unit.allUnits = {}

function Unit:_init(entity)
  self.valid = true
  self.squad = nil
  self.entity = entity

  entity.energy = 0
  setmetatable(self, Unit.mt)

  table.insert(Unit.allUnits, self)
end

function Unit:destroy()
  self.valid = false
  self.squad:remove_member(self)
end

Unit.remove = function(entity)
  for i, unit in pairs(Unit.allUnits) do
    if unit.entity == entity then
      unit:destroy()
      return
    end
  end
end

return Unit
