require "util"

function gun_turret_extension(inputs)
return
{
  filename = "__base__/graphics/entity/gun-turret/gun-turret-gun-extension.png",
  priority = "medium",
  width = 65,
  height = 63,
  direction_count = 4,
  frame_count = inputs.frame_count and inputs.frame_count or 5,
  line_length = inputs.line_length and inputs.line_length or 0,
  animation_speed = inputs.speed and inputs.speed or 1,
  run_mode = inputs.run_mode and inputs.run_mode or "forward",
  shift = {0.078125, -0.859375},
  axially_symmetrical = false
}
end

function gun_turret_extension_mask(inputs)
return
{
  filename = "__base__/graphics/entity/gun-turret/gun-turret-gun-extension-mask.png",
  width = 24,
  height = 31,
  direction_count = 4,
  frame_count = inputs.frame_count and inputs.frame_count or 5,
  line_length = inputs.line_length and inputs.line_length or 0,
  animation_speed = inputs.speed and inputs.speed or 1,
  run_mode = inputs.run_mode and inputs.run_mode or "forward",
  shift = {0.0625, -0.890625},
  axially_symmetrical = false,
  apply_runtime_tint = true
}
end

function gun_turret_extension_shadow(inputs)
return
{
  filename = "__base__/graphics/entity/gun-turret/gun-turret-gun-extension-shadow.png",
  width = 89,
  height = 49,
  direction_count = 4,
  frame_count = inputs.frame_count and inputs.frame_count or 5,
  line_length = inputs.line_length and inputs.line_length or 0,
  animation_speed = inputs.speed and inputs.speed or 1,
  run_mode = inputs.run_mode and inputs.run_mode or "forward",
  shift = {1.26563, 0.015625},
  axially_symmetrical = false,
  draw_as_shadow = true
}
end

function gun_turret_attack(inputs)
return
{
  layers =
  {
    {
      width = 66,
      height = 64,
      frame_count = inputs.frame_count and inputs.frame_count or 2,
      axially_symmetrical = false,
      direction_count = 64,
      shift = {0.0625, -0.875},
      stripes =
      {
        {
          filename = "__base__/graphics/entity/gun-turret/gun-turret-gun-1.png",
          width_in_frames = inputs.frame_count and inputs.frame_count or 2,
          height_in_frames = 32,
        },
        {
          filename = "__base__/graphics/entity/gun-turret/gun-turret-gun-2.png",
          width_in_frames = inputs.frame_count and inputs.frame_count or 2,
          height_in_frames = 32,
        }
      }
    },
    {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-gun-mask.png",
      line_length = inputs.frame_count and inputs.frame_count or 2,
      width = 29,
      height = 27,
      frame_count = inputs.frame_count and inputs.frame_count or 2,
      axially_symmetrical = false,
      direction_count = 64,
      shift = {0.078125, -1.01563},
      apply_runtime_tint = true
    },
    {
      width = 91,
      height = 50,
      frame_count = inputs.frame_count and inputs.frame_count or 2,
      axially_symmetrical = false,
      direction_count = 64,
      shift = {1.29688, 0},
      draw_as_shadow = true,
      stripes =
      {
        {
          filename = "__base__/graphics/entity/gun-turret/gun-turret-gun-shadow-1.png",
          width_in_frames = inputs.frame_count and inputs.frame_count or 2,
          height_in_frames = 32,
        },
        {
          filename = "__base__/graphics/entity/gun-turret/gun-turret-gun-shadow-2.png",
          width_in_frames = inputs.frame_count and inputs.frame_count or 2,
          height_in_frames = 32,
        }
      }
    }
  }
}
end


data:extend(
{
  {
    type = "item",
    name = "bambi-turret",
    icon = "__base__/graphics/icons/gun-turret.png",
    flags = {"goes-to-quickbar"},
    subgroup = "defensive-structure",
    order = "b[turret]-a[bambi-turret]",
    place_result = "bambi-turret",
    stack_size = 10
  },
  {
    type = "unit",
    name = "bambi-turret",
    icon = "__base__/graphics/icons/gun-turret.png",
    flags = {"placeable-player", "player-creation", "placeable-off-grid"},
    order="b-b-b",
    subgroup="enemies",
    minable = {mining_time = 0.5, result = "bambi-turret"},
    max_health = 400,
    corpse = "medium-remnants",
    collision_box = {{-0.7, -0.7 }, {0.7, 0.7}},
    selection_box = {{-1, -1 }, {1, 1}},
    rotation_speed = 0.015,
    preparing_speed = 0.08,
    folding_speed = 0.08,
    dying_explosion = "medium-explosion",
    inventory_size = 1,
    automated_ammo_count = 10,
    attacking_speed = 0.5,
    movement_speed = 0.085,
    distance_per_frame = 0.15,
    folded_animation = 
    {
      layers =
      {
        gun_turret_extension{frame_count=1, line_length = 1},
        gun_turret_extension_mask{frame_count=1, line_length = 1},
        gun_turret_extension_shadow{frame_count=1, line_length = 1}
      }
    },
    run_animation = 
    {
      layers =
      {
        gun_turret_extension{speed=0.5},
        gun_turret_extension_mask{speed=0.5},
        gun_turret_extension_shadow{speed=0.5},
      }
    },
    preparing_animation = 
    {
      layers =
      {
        gun_turret_extension{},
        gun_turret_extension_mask{},
        gun_turret_extension_shadow{}
      }
    },
    prepared_animation = gun_turret_attack{frame_count=1},
    folding_animation = 
    { 
      layers = 
      { 
        gun_turret_extension{run_mode = "backward"},
        gun_turret_extension_mask{run_mode = "backward"},
        gun_turret_extension_shadow{run_mode = "backward"}
      }
    },
    base_picture =
    {
      layers =
      {
        {
          filename = "__base__/graphics/entity/gun-turret/gun-turret-base.png",
          priority = "high",
          width = 90,
          height = 75,
          axially_symmetrical = false,
          direction_count = 1,
          shift = {0.0625, -0.046875},
        },
        {
          filename = "__base__/graphics/entity/gun-turret/gun-turret-base-mask.png",
          line_length = 1,
          width = 52,
          height = 47,
          frame_count = 1,
          axially_symmetrical = false,
          direction_count = 1,
          shift = {0.0625, -0.234375},
          apply_runtime_tint = true
        }
      }
    },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    dying_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    pollution_to_join_attack = 1,
    distraction_cooldown = 300,
    vision_distance = 30,
    attack_parameters =
    {
      type = "projectile",
      cooldown = 6,
      projectile_creation_distance = 1.39375,
      projectile_center = {0.0625, -0.0875}, -- same as gun_turret_attack shift
      damage_modifier = 2,
      animation = gun_turret_attack{},
      ammo_type =
      {
        category = "bullet",
        action =
        {
          type = "direct",
          action_delivery =
          {
            type = "instant",
            source_effects =
            {
              type = "create-explosion",
              entity_name = "explosion-gunshot"
            },
            target_effects =
            {
              {
                type = "create-entity",
                entity_name = "explosion-hit"
              },
              {
                type = "damage",
                damage = { amount = 5 , type = "physical"}
              }
            }
          }
        }
      },
      range = 3,
      sound = make_heavy_gunshot_sounds(),
    },
  },
})
