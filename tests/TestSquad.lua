require "defines"
local luaunit = require("lib.luaunit")
local Squad = require("classes.Squad")
local mydefines = require("lib.defines")

local TestSquad = {}
  function TestSquad:testCreate()
    local position = {x=0,y=0}
    local s = Squad(game.player, {x=0,y=0})

    luaunit.assertNotNil(s.unit_group, "TestSquad: UnitGroup not created")
    luaunit.assertEquals(s.command, mydefines.ai.command_type.idle, "TestSquad: Command type not set")
    luaunit.assertEquals(s.unit_group.position, position, "TestSquad: Position not set")
    luaunit.assertEquals(s.force.name, game.player.force.name, "TestSquad: Force not set")
    luaunit.assertEquals(s.player.index, game.player.index, "TestSquad: Player not set")

    s = Squad(game.player)
    luaunit.assertEquals(s.unit_group.position, game.player.position, "TestSquad: Position not set")
  end

  function TestSquad:testValidate()
    local s = Squad(game.player)
    luaunit.assertTrue(s.unit_group.valid, "TestSquad: UnitGroup not valid")

    s:validate()
    luaunit.assertNotEquals(s.unit_group, ug, "TestSquad: UnitGroup not recreated")
    luaunit.assertTrue(s.unit_group.valid, "TestSquad: UnitGroup not valid")
  end

  function TestSquad:testSetCommand()
    local s = Squad(game.player)

    luaunit.assertEquals(s.command, mydefines.ai.command_type.idle, "TestSquad: Command not idle")
    s:set_command({command=mydefines.ai.command_type.follow, entity=game.player.character})
    luaunit.assertEquals(s.command, mydefines.ai.command_type.follow, "TestSquad: Command not follow")
    luaunit.assertEquals(s.followee.name, game.player.character.name, "TestSquad: Followee not set")
  end

  function TestSquad:testAddMember()
    local s = Squad(game.player)

    luaunit.assertEquals(#s.unit_group.members, 0, "TestSquad: Members not empty")

    s:add_member({entity=game.player.surface.create_entity({name="bambi-turret", position=s.unit_group.position, force="player"})})
    luaunit.assertEquals(#s.unit_group.members, 1, "TestSquad: Incorrect number of members")

    s:add_member({entity=game.player.surface.create_entity({name="bambi-turret", position=s.unit_group.position, force="player"})})
    luaunit.assertEquals(#s.unit_group.members, 2, "TestSquad: Incorrect number of members")
  end

  function TestSquad:testFollow()
    p = game.player

    local s = Squad(p)
    s:add_member({entity=p.surface.create_entity({name="bambi-turret", position=p.position, force="player"})})
    s:add_member({entity=p.surface.create_entity({name="bambi-turret", position=p.position, force="player"})})
    s:add_member({entity=p.surface.create_entity({name="bambi-turret", position=p.position, force="player"})})

    s:go()

    luaunit.assertEquals(s.unit_group.state, defines.groupstate.gathering, "TestSqaud: UnitGroup not idle")

    p.character.teleport({x=10,y=10})
    s:set_command({command=mydefines.ai.command_type.follow, entity=p.character})
    s:go()

    luaunit.assertEquals(s.unit_group.state, defines.groupstate.moving, "TestSqaud: UnitGroup not moving")
  end

  function TestSquad:testDestroy()
    local s = Squad(game.player)

    s:destroy()

  end

return TestSquad
