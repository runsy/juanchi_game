local modpath, S = ...

local settings = Settings(modpath .. "/petz.conf")
local user = Settings(modpath .. "/user.conf")

--A list with all the petz names
petz.settings.petz_list = user:get("petz_list", "") or settings:get("petz_list", "")
petz.petz_list = string.split(petz.settings.petz_list, ',')
petz.settings.disable_monsters = user:get_bool("disable_monsters", false) or settings:get_bool("disable_monsters", false)
petz.settings.type_model = user:get("type_model", "mesh") or settings:get("type_model", "mesh")
--Tamagochi Mode
petz.settings.tamagochi_mode = user:get_bool("tamagochi_mode", true) or settings:get_bool("tamagochi_mode", true)
petz.settings.tamagochi_check_time = tonumber(user:get("tamagochi_check_time") or settings:get("tamagochi_check_time"))
petz.settings.tamagochi_reduction_factor = tonumber(user:get("tamagochi_reduction_factor") or settings:get("tamagochi_reduction_factor")) or 0.1
petz.settings.tamagochi_punch_rate = tonumber(user:get("tamagochi_punch_rate") or settings:get("tamagochi_punch_rate")) or 0.1
petz.settings.tamagochi_feed_hunger_rate = tonumber(user:get("tamagochi_feed_hunger_rate") or settings:get("tamagochi_feed_hunger_rate")) or 0.1
petz.settings.tamagochi_brush_rate = tonumber(user:get("tamagochi_brush_rate") or settings:get("tamagochi_brush_rate")) or 0.1
petz.settings.tamagochi_beaver_oil_rate = tonumber(user:get("tamagochi_beaver_oil_rate") or settings:get("tamagochi_beaver_oil_rate")) or 0.1
petz.settings.tamagochi_lashing_rate = tonumber(user:get("tamagochi_lashing_rate") or settings:get("tamagochi_lashing_rate")) or 0.1
petz.settings.tamagochi_check_if_player_online = user:get_bool("tamagochi_check_if_player_online", true) or settings:get_bool("tamagochi_check_if_player_online", true)
petz.settings.tamagochi_hungry_warning = tonumber(user:get("tamagochi_hungry_warning") or settings:get("tamagochi_hungry_warning")) or 0.5
--Create a table with safe nodes
local tamagochi_safe_nodes = user:get("tamagochi_safe_nodes", "") or settings:get("tamagochi_safe_nodes", "")
petz.settings.tamagochi_safe_nodes = {} --Table with safe nodes for tamagochi mode
petz.settings.tamagochi_safe_nodes = string.split(tamagochi_safe_nodes, ',')
--Enviromental Damage
petz.settings.air_damage = tonumber(user:get("air_damage") or settings:get("air_damage"))
petz.settings.igniter_damage = tonumber(user:get("igniter_damage") or settings:get("igniter_damage")) --lava & fire
--API Type
petz.settings.type_api = user:get("type_api", "mobs_redo") or settings:get("type_api", "mobs_redo")
--Capture Mobs
petz.settings.lasso = user:get("lasso", "petz:lasso") or settings:get("lasso", "petz:lasso")
petz.settings.rob_mobs = user:get_bool("rob_mobs", false) or settings:get_bool("rob_mobs", false)
--Shears
petz.settings.shears = user:get("shears", "petz:shears") or settings:get("shears", "petz:shears")
--Look at
petz.settings.look_at = user:get_bool("look_at", true) or settings:get_bool("look_at", true)
--Selling
petz.settings.selling = user:get_bool("selling", false) or settings:get_bool("selling", false)
petz.settings.selling_exchange_items = string.split(user:get("selling_exchange_items", "") or settings:get("selling_exchange_items", ""), ",")
petz.settings.selling_exchange_items_list = {}
for i = 1, #petz.settings.selling_exchange_items do
	local exchange_item = petz.settings.selling_exchange_items[i]
	local exchange_item_description = minetest.registered_items[exchange_item].description
	local exchange_item_inventory_image = minetest.registered_items[exchange_item].inventory_image
	if exchange_item_description then
		petz.settings.selling_exchange_items_list[i] = {name = exchange_item, description = exchange_item_description, inventory_image = exchange_item_inventory_image}
	end
end
--Spawn Engine
petz.settings.spawn_interval = tonumber(user:get("spawn_interval") or settings:get("spawn_interval"))
petz.settings.spawn_chance = tonumber(user:get("spawn_chance") or settings:get("spawn_chance"))
petz.settings.max_mobs = tonumber(user:get("max_mobs") or settings:get("max_mobs"))
petz.settings.no_spawn_in_protected = user:get_bool("no_spawn_in_protected", false) or settings:get_bool("no_spawn_in_protected", false)
petz.settings.spawn_peaceful_monsters_ratio = mokapi.delimit_number(tonumber(user:get("spawn_peaceful_monsters_ratio") or settings:get("spawn_peaceful_monsters_ratio")) or 1.0, {min=0.0, max=1.0})
--Lifetime
petz.settings.lifetime = tonumber(user:get("lifetime", "-1") or settings:get("lifetime", "-1"))
petz.settings.lifetime_variability = tonumber(user:get("lifetime_variability", "0.2") or settings:get("lifetime_variability", "0.2"))
petz.settings.lifetime_only_non_tamed = user:get_bool("lifetime_only_non_tamed", false) or settings:get_bool("lifetime_only_non_tamed", false)
petz.settings.lifetime_avoid_non_breedable = user:get_bool("lifetime_avoid_non_breedable", false) or settings:get_bool("lifetime_avoid_non_breedable", false)
--Lay Eggs
petz.settings.lay_egg_chance = tonumber(user:get("lay_egg_chance") or settings:get("lay_egg_chance"))
--Misc Random Sound Chance
petz.settings.misc_sound_chance = tonumber(user:get("misc_sound_chance") or settings:get("misc_sound_chance"))
petz.settings.max_hear_distance = tonumber(user:get("max_hear_distance") or settings:get("max_hear_distance"))
--Fly Behaviour
petz.settings.fly_check_time = tonumber(user:get("fly_check_time") or settings:get("fly_check_time"))
--Breed Engine
petz.settings.pregnant_count = tonumber(user:get("pregnant_count") or settings:get("pregnant_count"))
petz.settings.pregnancy_time = tonumber(user:get("pregnancy_time") or settings:get("pregnancy_time"))
petz.settings.growth_time = tonumber(user:get("growth_time") or settings:get("growth_time"))
--Punch Effect
petz.settings.colorize_punch = user:get_bool("colorize_punch", true) or settings:get_bool("colorize_punch", true)
petz.settings.punch_color = user:get("punch_color", "#FF0000") or settings:get("punch_color", "#FF0000")
--Blood
petz.settings.blood = user:get_bool("blood", false) or settings:get_bool("blood", false)
--Blood
petz.settings.poop = user:get_bool("poop", true) or settings:get_bool("poop", true)
petz.settings.poop_rate = tonumber(user:get("poop_rate", "200") or settings:get("poop_rate", "200"))
petz.settings.poop_decay = tonumber(user:get("poop_decay", "1200") or settings:get("poop_decay", "1200"))
--Smoke particles when die
petz.settings.death_effect = user:get_bool("death_effect", true) or settings:get_bool("death_effect", true)
--Look_at
petz.settings.look_at = user:get_bool("look_at", true) or settings:get_bool("look_at", true)
petz.settings.look_at_random = tonumber(user:get("look_at_random", "10") or settings:get("look_at_random", "10"))
--Cobweb
petz.settings.cobweb_decay = tonumber(user:get("cobweb_decay", "1200") or settings:get("cobweb_decay", "1200"))
--Mount Pointable Driver
petz.settings.pointable_driver = user:get_bool("pointable_driver", true) or settings:get_bool("pointable_driver", true)
petz.settings.gallop_time = tonumber(user:get("gallop_time", "5") or settings:get("gallop_time", "5"))
petz.settings.gallop_recover_time =  tonumber(user:get("gallop_recover_time", "5") or settings:get("gallop_recover_time", "5"))
--Sleeping
petz.settings.sleeping = user:get_bool("sleeping", true) or settings:get_bool("sleeping", true)
--Herding
petz.settings.herding = user:get_bool("herding", true) or settings:get_bool("herding", true)
petz.settings.herding_timing = tonumber(user:get("herding_timing", "3") or settings:get("herding_timing", "3"))
petz.settings.herding_members_distance = tonumber(user:get("herding_members_distance", "5") or settings:get("herding_members_distance", "5"))
petz.settings.herding_shepherd_distance = tonumber(user:get("herding_shepherd_distance", "5") or settings:get("herding_shepherd_distance", "5"))
--Lashing
petz.settings.lashing_tame_count = tonumber(user:get("lashing_tame_count", "3") or settings:get("lashing_tame_count", "3"))
--Bee Stuff
petz.settings.initial_honey_behive = tonumber(user:get("initial_honey_behive", "3") or settings:get("initial_honey_behive", "3"))
petz.settings.max_honey_behive = tonumber(user:get("max_honey_behive", "10") or settings:get("max_honey_behive", "10"))
petz.settings.max_bees_behive = tonumber(user:get("max_bees_behive", "3") or settings:get("max_bees_behive", "3"))
petz.settings.bee_outing_ratio = tonumber(user:get("bee_outing_ratio", "20") or settings:get("bee_outing_ratio", "20"))
--petz.settings.behive_spawn_chance  = tonumber(settings:get("behive_spawn_chance")) or 0.0
--petz.settings.max_behives_in_area  = tonumber(settings:get("max_behives_in_area")) or 0.0
--Weapons
petz.settings.pumpkin_grenade_damage = tonumber(user:get("pumpkin_grenade_damage", "8") or settings:get("pumpkin_grenade_damage", "8"))
--Horseshoes
petz.settings.horseshoe_speedup = tonumber(user:get("horseshoe_speedup", "1") or settings:get("horseshoe_speedup", "1"))
--Population Control
petz.settings.max_tamed_by_owner = tonumber(user:get("max_tamed_by_owner", "-1") or settings:get("max_tamed_by_owner", "-1"))
--Lycanthropy
petz.settings.lycanthropy = user:get_bool("lycanthropy", true) or settings:get_bool("lycanthropy", true)
petz.settings.lycanthropy_infection_chance_by_wolf = tonumber(user:get("lycanthropy_infection_chance_by_wolf", "200") or settings:get("lycanthropy_infection_chance_by_wolf", "200"))
petz.settings.lycanthropy_infection_chance_by_werewolf = tonumber(user:get("lycanthropy_infection_chance_by_werewolf", "10") or settings:get("lycanthropy_infection_chance_by_werewolf", "10"))
--Server Cron Tasks
petz.settings.clear_mobs_time = tonumber(user:get("clear_mobs_time", "0") or settings:get("clear_mobs_time", "0"))
--Mobs Specific
for i = 1, #petz.petz_list do --load the settings
	local petz_type = petz.petz_list[i]
	petz.settings[petz_type.."_spawn"]  = user:get_bool(petz_type.."_spawn", false) or settings:get_bool(petz_type.."_spawn", false)
	petz.settings[petz_type.."_spawn_chance"]  = tonumber(user:get(petz_type.."_spawn_chance") or settings:get(petz_type.."_spawn_chance")) or 0.0
	petz.settings[petz_type.."_spawn_nodes"]  = user:get(petz_type.."_spawn_nodes", "") or settings:get(petz_type.."_spawn_nodes", "")
	petz.settings[petz_type.."_spawn_biome"]  = user:get(petz_type.."_spawn_biome", "default") or settings:get(petz_type.."_spawn_biome", "default")
	petz.settings[petz_type.."_spawn_herd"] = tonumber(user:get(petz_type.."_spawn_herd") or settings:get(petz_type.."_spawn_herd")) or 1
	petz.settings[petz_type.."_seasonal"] = user:get(petz_type.."_seasonal", "") or settings:get(petz_type.."_seasonal", "")
	petz.settings[petz_type.."_follow"] = user:get(petz_type.."_follow", "") or settings:get(petz_type.."_follow", "")
	petz.settings[petz_type.."_breed"]  = user:get(petz_type.."_breed", "") or settings:get(petz_type.."_breed", "")
	petz.settings[petz_type.."_predators"]  = user:get(petz_type.."_predators", "") or settings:get(petz_type.."_predators", "")
	petz.settings[petz_type.."_preys"] = user:get(petz_type.."_preys", "") or settings:get(petz_type.."_preys", "")
	petz.settings[petz_type.."_colorized"] = user:get_bool(petz_type.."_colorized", false) or settings:get_bool(petz_type.."_colorized", false)
	petz.settings[petz_type.."_copulation_distance"] = tonumber(user:get(petz_type.."_copulation_distance") or settings:get(petz_type.."_copulation_distance")) or 0.0
	petz.settings[petz_type.."_convert"] = user:get(petz_type.."_convert", nil) or settings:get(petz_type.."_convert", nil)
	petz.settings[petz_type.."_convert_to"] = user:get(petz_type.."_convert_to", nil) or settings:get(petz_type.."_convert_to", nil)
	petz.settings[petz_type.."_convert_count"] = tonumber(user:get(petz_type.."_convert_count") or settings:get(petz_type.."_convert_count")) or nil
	petz.settings[petz_type.."_lifetime"] = tonumber(user:get(petz_type.."_lifetime") or settings:get(petz_type.."_lifetime")) or nil
	if petz_type == "beaver" then
		petz.settings[petz_type.."_create_dam"] = user:get_bool(petz_type.."_create_dam", false) or settings:get_bool(petz_type.."_create_dam", false)
	elseif petz_type == "silkworm" then
		petz.settings[petz_type.."_lay_egg_on_node"] = user:get(petz_type.."_lay_egg_on_node", "") or settings:get(petz_type.."_lay_egg_on_node", "")
	end
end

petz.settings.visual = "mesh"
petz.settings.visual_size = {x=10, y=10}
petz.settings.rotate = 0
