global.selectable_entities = {
  "bambi-turret",
}

global.mouseover = {ticks=0, entity=nil}

select_entity = function() 
  if game.player.selected == nil then 
    global.mouseover.entity = nil
    global.mouseover.ticks = 0
  else
    if in_array(game.player.selected.name, global.select_entities) then 
      if game.player.selected == global.mouseover.entity then 
        global.mouseover.ticks = global.mouseover.ticks + 1
        if global.mouseover.ticks == 50 then
          global.selected = global.mouseover.entity
        end
      else
        global.mouseover.ticks = 0
      end
    else 
      global.mouseover.entity = nil
      global.mouseover.ticks = 0
    end
  end

  global.mouseover.entity = game.player.selected

  if global.selected ~= nil then
    game.player.set_gui_arrow{type="entity", entity=global.selected}
  else 
    game.player.clear_gui_arrow()
  end
end

script.on_event(defines.events.on_tick, function(event)
  select_entity()
end)
