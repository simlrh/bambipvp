local test = {}
local util = require("lib.util")
local luaunit = require("lib.luaunit")

test.tests = {
  "tests.TestUnit",
  "tests.TestSquad",
}

for i, t in ipairs(test.tests) do
  p = util.split(t, '.')
  _G[p[2]] = require(t)
end

test.run = function()
  test.init_logging()
  local failed = luaunit.LuaUnit.run()
  test.finish_logging(failed)

  game.set_game_state{game_finished = true, player_won = false}
end

test.init_logging = function()
  game.player.gui.top.add{type = "frame", caption = "Test Results", name = "test_frame", direction = "vertical"} 
  test.gui = game.player.gui.top.test_frame
  test.logid = 1
  test.print = print
  print = test.log
end

test.log = function(message)
  test.gui.add{type = "label", caption = message, name = "test_log_"..test.logid}
  test.logid = test.logid + 1
end

test.finish_logging = function(failed)
  if failed > 0 then
    print("Tests failed")
  else
    print ("All tests passed")
  end
  print = test.print
  
  test.succeeded = failed == 0
end

os = {
  clock = function()
    return game.tick
  end,
  date = function()
    return game.tick
  end,
  getenv = function()
    return 0
  end,
  exit = function()
  end
}

io = {
  stdout = {
    write = function(s, ...)
      local message = string.format(...)
      print(message)
    end
  }
}

return test
