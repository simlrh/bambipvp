require "defines"

script.on_event(defines.events.on_player_created, function(event)
  remote.call("bambipvp", "runtests")
end)
