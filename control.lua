bambipvp = {}

bambipvp.log = require("lib.logging")
bambipvp.test = require("lib.test")
bambipvp.ai = require("lib.ai")

remote.add_interface("bambipvp", {
  runtests = function() 
    bambipvp.test.run()
  end
})

script.on_event(defines.events.on_tick, function(event)
  bambipvp.ai.tick()
end)
