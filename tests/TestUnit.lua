require "defines"
local luaunit = require("lib.luaunit")
local Unit = require("classes.Unit")
local mydefines = require("lib.defines")

local TestUnit = {}
  function TestUnit:testCreate()
    local u = Unit(game.player.surface.create_entity({name="bambi-turret", position=game.player.position}))
    luaunit.assertNotNil(u.entity, "TestUnit: Unit not created")
  end

return TestUnit
