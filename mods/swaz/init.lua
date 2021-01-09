local S = minetest.get_translator(minetest.get_current_modname())
local mg_name = minetest.get_mapgen_setting("mg_name")

-- Register Biomes

minetest.register_biome({
	name = "swampz",
	node_top = "swaz:silt_with_grass",
	depth_top = 1,
	node_filler = "swaz:silt",
	depth_filler = 3,
	node_riverbed = "default:sand",
	depth_riverbed = 2,
	node_water = "swaz:water_source",
	depth_water_top = 5,
	node_water_top = "swaz:water_source",
	node_stone = "swaz:limestone",
	y_max = 7,
	y_min = 1,
	heat_point = 80,
	humidity_point = 89,
	vertical_blend = 0,
})

minetest.register_biome({
	name = "swampz_shore",
	node_top = "swaz:mud",
	depth_top = 1,
	node_filler = "swaz:mud",
	depth_filler = 3,
	node_riverbed = "default:sand",
	depth_riverbed = 2,
	node_water = "swaz:water_source",
	depth_water_top = 5,
	node_water_top = "swaz:water_source",
	y_max = 0,
	y_min = -5,
	heat_point = 79,
	humidity_point = 90,
	vertical_blend = 0,
})

-- Register Nodes

minetest.register_node("swaz:silt_with_grass", {
	description = S("Silt with Grass"),
	tiles = {"swaz_grass.png", "swaz_silt.png",
		{name = "swaz_silt.png^swaz_silt_with_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "swaz:mud",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_node("swaz:limestone", {
	description = S("Limestone"),
	tiles = {"swaz_limestone.png"},
	groups = {cracky = 3, stone = 1},
	drop = "swaz:limestone",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("swaz:mud", {
	description = S("Mud"),
	tiles = {"swaz_mud.png"},
	groups = {crumbly = 3, soil = 1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("swaz:mud_with_moss", {
	description = S("Mud with Moss"),
	tiles = {"swaz_moss.png", "swaz_mud.png",
		{name = "swaz_mud.png^swaz_mud_with_moss_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1},
	drop = "swaz:mud",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_node("swaz:silt", {
	description = S("Silt"),
	tiles = {"swaz_silt.png"},
	groups = {crumbly = 3, soil = 1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_craft({
	output = "swaz:silt",
	type = "shapeless",
	recipe = {"group:soil", "bucket:bucket_water"},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}}
})

minetest.register_node("swaz:water_source", {
	description = S("Muddy Water Source"),
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{
			name = "swaz_water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "swaz_water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	alpha = 212,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "swaz:water_flowing",
	liquid_alternative_source = "swaz:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 191, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})

minetest.register_node("swaz:water_flowing", {
	description = S("Flowing Muddy Water"),
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"swaz_muddy_water.png"},
	special_tiles = {
		{
			name = "swaz_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
		{
			name = "swaz_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
	},
	alpha = 212,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "swaz:water_flowing",
	liquid_alternative_source = "swaz:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 191, r = 30, g = 90, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
		cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})

minetest.register_node("swaz:reed", {
	description = S("Reed"),
	drawtype = "plantlike",
	tiles = {"swaz_reed.png"},
	inventory_image = "swaz_reed.png",
	wield_image = "swaz_reed.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-1 / 16, -0.5, -1 / 16, 1 / 16, 0.5, 1 / 16},
	},
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),

	after_dig_node = function(pos, node, metadata, digger)
		default.dig_up(pos, node, digger)
	end,
})

minetest.register_node("swaz:swamp_grass", {
	description = S("Swamp Grass"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 0.8,
	tiles = {"swaz_swamp_grass.png"},
	inventory_image = "swaz_swamp_grass.png",
	wield_image = "swaz_swamp_grass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 0.0, 4 / 16},
	},
})

minetest.register_node("swaz:pampas_grass", {
	description = S("Pampas Grass"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 0.9,
	tiles = {"swaz_pampas_grass.png"},
	inventory_image = "swaz_pampas_grass.png",
	wield_image = "swaz_pampas_grass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 0.0, 4 / 16},
	},
})

minetest.register_node("swaz:lavender", {
	description = S("Lavender"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.0,
	tiles = {"swaz_lavender.png"},
	inventory_image = "swaz_lavender.png",
	wield_image = "swaz_lavender.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flower = 1, flora = 1, attached_node = 1, flammable = 1, color_violet = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-2 / 16, -0.5, -2 / 16, 2 / 16, 0, 2 / 16},
	},
})

--Barberry Bush Stuff

-- Required wrapper to allow customization of default.after_place_leaves
local function after_place_leaves(...)
	return default.after_place_leaves(...)
end

minetest.register_craftitem("swaz:barberries", {
	description = S("Barberries"),
	inventory_image = "swaz_barberries.png",
	groups = {food_barberries = 1, food_berry = 1},
	on_use = minetest.item_eat(2),
})

minetest.register_node("swaz:barberry_bush_leaves_with_berries", {
	description = S("Barberry Bush Leaves with Berries"),
	drawtype = "plantlike",
	tiles = {"swaz_barberry_bush_leaves.png^swaz_barberry_overlay.png"},
	inventory_image = "swaz_barberry_bush_leaves.png^swaz_barberry_overlay.png",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, dig_immediate = 3},
	drop = "swaz:barberries",
	sounds = default.node_sound_leaves_defaults(),
	node_dig_prediction = "swaz:barberry_bush_leaves",
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 2 / 16, 4 / 16}
	},

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		minetest.set_node(pos, {name = "swaz:barberry_bush_leaves"})
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,
})

minetest.register_node("swaz:barberry_bush_leaves", {
	description = S("Barberry Bush Leaves"),
	drawtype = "plantlike",
	tiles = {"swaz_barberry_bush_leaves.png"},
	inventory_image = "swaz_barberry_bush_leaves.png",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"swaz:barberry_bush_sapling"}, rarity = 5},
			{items = {"swaz:barberry_bush_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
		selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 2 / 16, 4 / 16}
	},

	on_timer = function(pos, elapsed)
		if minetest.get_node_light(pos) < 11 then
			minetest.get_node_timer(pos):start(200)
		else
			minetest.set_node(pos, {name = "swaz:barberry_bush_leaves_with_berries"})
		end
	end,

	after_place_node = after_place_leaves,
})

minetest.register_node("swaz:barberry_bush_sapling", {
	description = S("Barberry Bush Sapling"),
	drawtype = "plantlike",
	tiles = {"swaz_barberry_bush_sapling.png"},
	inventory_image = "swaz_barberry_bush_sapling.png",
	wield_image = "swaz_barberry_bush_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = function(pos, elapsed)
		minetest.set_node(pos, {name = "swaz:barberry_bush_leaves"})
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,
	selection_box = {
		type = "fixed",
		fixed = {-2 / 16, -0.5, -1 / 16, 2 / 16, -2 / 16, 2 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"swaz:barberry_bush_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			{x = -1, y = 0, z = -1},
			{x = 1, y = 1, z = 1},
			-- maximum interval of interior volume check
			2)

		return itemstack
	end,
})

--Iris Flower

minetest.register_node("swaz:iris_top", {
	description = S("Iris").. " ("..S("flower")..")",
	drawtype = "plantlike",
	visual_scale = 0.8,
	tiles = {"swaz_iris_top.png"},
	inventory_image = "swaz_iris_flower.png",
	paramtype = "light",
	walkable = false,
	waving = 1,
	groups = {snappy = 3, flammable = 3, flower =1, flora=1, not_in_creative_inventory = 1},
	sounds = default.node_sound_leaves_defaults(),
	drop = "swaz:iris",
	selection_box = {
		type = "fixed",
		fixed = {-0.1875, -0.5, -0.1875, 0.1875, 0.1875, 0.1875}
	},
	after_destruct = function(pos, oldnode)
		pos.y = pos.y - 2
		local node = minetest.get_node_or_nil(pos)
		if node and node.name == "swaz:iris" then
			minetest.swap_node(pos, {name = "swaz:mud"})
		end
	end
})

minetest.register_node("swaz:iris", {
	description = S("Iris"),
	drawtype = "plantlike_rooted",
	visual_scale = 1.0,
	tiles = {"swaz_mud.png"},
	special_tiles = {
		nil,
		nil,
		"swaz_iris_base.png",
		"swaz_iris_base.png",
		"swaz_iris_base.png",
		"swaz_iris_base.png",
	},
	inventory_image = "swaz_iris_top_inv.png",
	wield_image = "swaz_iris_top_inv.png",
	paramtype = "light",
	walkable = false,
	waving = 1,
	groups = {snappy = 3, flammable = 3, flower =1, flora=1, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	},

	on_construct = function(pos)
		pos.y = pos.y + 2
		minetest.swap_node(pos, {name = "swaz:iris_top"})
	end,

	after_destruct = function(pos, oldnode)
		pos.y = pos.y + 2
		local node = minetest.get_node_or_nil(pos)
		if node and node.name == "swaz:iris_top" then
			minetest.remove_node(pos)
		end
	end,

	on_place = function(itemstack, placer, pointed_thing)
		-- Call on_rightclick if the pointed node defines it
		if pointed_thing.type == "node" and placer and
				not placer:get_player_control().sneak then
			local node_ptu = minetest.get_node(pointed_thing.under)
			local def_ptu = minetest.registered_nodes[node_ptu.name]
			if def_ptu and def_ptu.on_rightclick then
				return def_ptu.on_rightclick(pointed_thing.under, node_ptu, placer,
					itemstack, pointed_thing)
			end
		end
		local pos = pointed_thing.under
		if minetest.get_node(pos).name ~= "swaz:mud" or pos.y < 0 then
			return itemstack
		end
		local height = 1
		local pos_top = {x = pos.x, y = pos.y + 1, z = pos.z}
		local node_top = minetest.get_node(pos_top)
		local def_top = minetest.registered_nodes[node_top.name]
		local player_name = placer:get_player_name()


			if not minetest.is_protected(pos, player_name) and
					not minetest.is_protected(pos_top, player_name) then
				minetest.set_node(pos, {name= "swaz:iris",
					param2 = height * 16})
				if not (creative and creative.is_enabled_for
						and creative.is_enabled_for(player_name)) then
					itemstack:take_item()
				end
			else
				minetest.chat_send_player(player_name, S("Node is protected"))
				minetest.record_protection_violation(pos, player_name)
			end

	end,
})

-- Register Decoration
-- IMPORTANT!
-- THE ORDER OF THE DECORATION MATTERS!
-- DO NOT SORT

if mg_name ~= "v6" and mg_name ~= "singlenode" then

	--Water Source (4x4)

	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"swaz:silt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.05,
			scale = 0.05,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"swampz"},
		height = 2,
		y_min = 0,
		y_max = 1000,
		place_offset_y = -1,
		schematic = {
			size = {x = 4, y = 2, z = 4},
			data = {
				{name = "swaz:silt"}, {name = "swaz:silt"}, {name = "swaz:silt"},{name = "swaz:silt"},
				{name = "swaz:silt_with_grass"}, {name = "swaz:silt_with_grass"}, {name = "swaz:silt_with_grass"},{name = "swaz:silt_with_grass"},
				{name = "swaz:silt"}, {name = "swaz:silt"}, {name = "swaz:silt"},{name = "swaz:silt"},
				{name = "swaz:silt_with_grass"}, {name = "swaz:water_source"}, {name = "swaz:water_source"},{name = "swaz:silt_with_grass"},
				{name = "swaz:silt"}, {name = "swaz:silt"}, {name = "swaz:silt"},{name = "swaz:silt"},
				{name = "swaz:silt_with_grass"}, {name = "swaz:water_source"}, {name = "swaz:water_source"},{name = "swaz:silt_with_grass"},
				{name = "swaz:silt"}, {name = "swaz:silt"}, {name = "swaz:silt"},{name = "swaz:silt"},
				{name = "swaz:silt_with_grass"}, {name = "swaz:silt_with_grass"}, {name = "swaz:silt_with_grass"},{name = "swaz:silt_with_grass"},
			}
		},
		spawn_by = "swaz:silt_with_grass",
		num_spawn_by = 5,
		flags = "place_center_x, place_center_z, force_placement",
		rotation = "random",
	})

	--Water Source (1x1) --this goes after the 4x4 deco of swamp water

	minetest.register_decoration({
		deco_type = "simple",
		decoration = "swaz:water_source",
		place_on = {"swaz:silt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.8,
			scale = 0.8,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"swampz"},
		height = 2,
		y_min = 0,
		y_max = 1000,
		place_offset_y = -2,
		spawn_by = "swaz:water_source",
		num_spawn_by = 6,
		flags = "place_center_x, place_center_z, force_placement",
		rotation = "random",
	})

	--Mud with moss --this goes after water (depends on it)

	minetest.register_decoration({
		decoration = "swaz:mud_with_moss",
		deco_type = "simple",
		place_on = "swaz:silt_with_grass",
		sidelen = 16,
		fill_ratio = 0.1,
		biomes = {"swampz"},
		noise_params = {
			offset = 0.5,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
		spawn_by = "swaz:water_source",
		num_spawn_by = 1,
		place_offset_y = -1,
		flags = "place_center_x, place_center_z, force_placement",
	})

	--Bald Cypress

	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:dirt", "default:sand", "swaz:silt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.01,
			scale = 0.005,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"swampz"},
		height = 2,
		y_min = 0,
		y_max = 1000,
		place_offset_y = 0,
		schematic = minetest.get_modpath("baldcypress").."/schematics/baldcypress.mts",
		flags = "place_center_x, place_center_z, force_placement",
		rotation = "random",
	})

	--Willow

	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:dirt", "default:sand", "swaz:silt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.01,
			scale = 0.005,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"swampz"},
		height = 2,
		y_min = 0,
		y_max = 1000,
		place_offset_y = 0,
		schematic = minetest.get_modpath("willow").."/schematics/willow.mts",
		flags = "place_center_x, place_center_z, force_placement",
		rotation = "random",
	})

	--Mud  --this goes after mud with moss (depends on it)

	minetest.register_decoration({
		decoration = "swaz:mud",
		deco_type = "simple",
		place_on = "swaz:silt_with_grass",
		sidelen = 16,
		fill_ratio = 0.1,
		biomes = {"swampz"},
		noise_params = {
			offset = 0.5,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
		spawn_by = "swaz:mud_with_moss",
		num_spawn_by = 1,
		place_offset_y = -1,
		flags = "place_center_x, place_center_z, force_placement",
	})

	--Swamp Grass --this goes after water (depends on it)

	minetest.register_decoration({
		decoration = "swaz:swamp_grass",
		deco_type = "simple",
		place_on = "swaz:silt_with_grass",
		sidelen = 16,
		fill_ratio = 2.0,
		biomes = {"swampz"},
		noise_params = {
			offset = 0.8,
			scale = 0.08,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
		spawn_by = "swaz:water_source",
		num_spawn_by = 1,
		--num_spawn_by = 8,
	})

	--Pampa Grass  --this goes after water (depends on it)

	minetest.register_decoration({
		decoration = "swaz:pampas_grass",
		deco_type = "simple",
		place_on = "swaz:silt_with_grass",
		sidelen = 16,
		fill_ratio = 0.008,
		biomes = {"swampz"},
			noise_params = {
			offset = 0.01,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
		spawn_by = "swaz:water_source",
		num_spawn_by = 1,
	})

	--Reed --this goes after water (depends on it)

	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"swaz:silt_with_grass", "swaz:mud_with_moss", "swaz:mud"},
		sidelen = 16,
		noise_params = {
			offset = 0.05,
			scale = 0.005,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"swampz"},
		height = 2,
		y_min = 0,
		y_max = 1000,
		place_offset_y = 1,
		schematic = {
			size = {x = 1, y = 4, z = 1},
			data = {
				{name = "swaz:reed", force_place = true}, {name = "swaz:reed", force_place = true}, {name = "swaz:reed"}, {name = "swaz:reed"}
			}
		},
		spawn_by = "swaz:water_source",
		num_spawn_by = 1,
		flags = "place_center_x, place_center_z, force_placement",
		rotation = "random",
	})

	--Waterlily  --this goes after water (depends on it)

	minetest.register_decoration({
		decoration = "flowers:waterlily",
		deco_type = "simple",
		place_on = "swaz:water_source",
		sidelen = 16,
		fill_ratio = 0.008,
		biomes = {"swampz"},
		noise_params = {
			offset = 0.05,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 1000,
	})

	--Lavender

	minetest.register_decoration({
		decoration = "swaz:lavender",
		deco_type = "simple",
		place_on = "swaz:silt_with_grass",
		sidelen = 16,
		fill_ratio = 0.008,
		biomes = {"swampz"},
		noise_params = {
			offset = 0.005,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
	})

	--Barberry

	minetest.register_decoration({
		decoration = "swaz:barberry_bush_leaves_with_berries",
		deco_type = "simple",
		place_on = "swaz:silt_with_grass",
		biomes = {"swampz"},
		noise_params = {
			offset = 0.0008,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 2678,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
	})

	--Iris Flower

	minetest.register_decoration({
		name = "swaz:iris",
		decoration = "swaz:iris",
		deco_type = "schematic",
		schematic = {
			size = {x = 1, y = 3, z = 1},
			data = {
				{name = "swaz:iris"}, {name = "air"}, {name = "swaz:iris_top"},
			}
		},
		place_on = {"swaz:mud"},
		biomes = "swampz_shore",
		sidelen = 16,
		noise_params = {
			offset = -0.3,
			scale = 0.7,
			spread = {x = 100, y = 100, z = 100},
			seed = 354,
			octaves = 3,
			persist = 0.7
		},
		place_offset_y = 0,
		y_min = 0,
		y_max = 0,
		flags = "place_center_x, place_center_z, force_placement",
	})

end

-- Construction Materials

minetest.register_node("swaz:adobe", {
	description = S("Adobe Block"),
	tiles = {"swaz_adobe.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "swaz:adobe",
	type = "shapeless",
	recipe = {"swaz:mud", "farming:straw"},
})

minetest.register_node("swaz:mudbrick", {
	description = S("Mudbrick"),
	tiles = {"swaz_mudbrick.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "swaz:mudbrick",
	type = "shapeless",
	recipe = {"swaz:adobe", "swaz:adobe", "swaz:adobe", "swaz:adobe"},
})

minetest.register_node("swaz:brick_wall", {
	description = S("Brick Wall"),
	tiles = {"swaz_brick_wall.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "swaz:brick_wall",
	type = "cooking",
	cooktime = 3.0,
	recipe = "swaz:mudbrick",
})

minetest.register_node("swaz:mixed_brick_wall", {
	description = S("Mixed Brick Wall"),
	tiles = {"swaz_mixed_brick_wall.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "swaz:mixed_brick_wall",
	type = "shapeless",
	recipe = {"swaz:brick_wall", "dye:red", "dye:blue"},
})

minetest.register_node("swaz:sandy_brick_wall", {
	description = S("Sandy Brick Wall"),
	tiles = {"swaz_sandy_brick_wall.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "swaz:sandy_brick_wall",
	type = "shapeless",
	recipe = {"swaz:brick_wall", "default:sand"},
})

local cement_base

if minetest.get_modpath("basic_materials")~=nil then
	cement_base = "basic_materials:wet_cement"
else
	cement_base = "dye:grey"
end

minetest.register_node("swaz:cemented_brick_wall", {
	description = S("Cemented Brick Wall"),
	tiles = {"swaz_cemented_brick_wall.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "swaz:cemented_brick_wall",
	type = "shapeless",
	recipe = {"swaz:brick_wall", cement_base},
})

--Roof/Gables

minetest.register_node("swaz:roof_slope_red", {
	description = S("Red Roof Slope"),
	drawtype= "mesh",
	mesh = "swaz_roof_slope.b3d",
	tiles = {"swaz_red_roof.png"},
	use_texture_alpha = true,
	is_ground_content = false,
	paramtype2 = "facedir",
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.5, 0, 0, 0.5, 0.5, 0.5},
		}
	}
})

minetest.register_node("swaz:red_roof_corner", {
	description = S("Red Roof Corner"),
	drawtype= "mesh",
	mesh = "swaz_roof_corner.b3d",
	tiles = {"swaz_red_roof.png"},
	use_texture_alpha = true,
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("swaz:roof_flat_red", {
	description = S("Red Flat Roof"),
	tiles = {"swaz_red_gables.png", "swaz_adobe.png"},
	is_ground_content = false,
	paramtype2 = "facedir",
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

if minetest.get_modpath("stairs")~=nil then

	stairs.register_stair_and_slab(
		"adobe",
		"swaz:adobe",
		{cracky = 2, stone = 1},
		{"swaz_adobe.png"},
		S("Adobe Stair"),
		S("Adobe Slab"),
		default.node_sound_stone_defaults()
	)

	stairs.register_stair_and_slab(
		"adobe_brick",
		"swaz:mudbrick",
		{cracky = 2, stone = 1},
		{"swaz_mudbrick.png"},
		S("Mudbrick Stair"),
		S("Mudbrick Slab"),
		default.node_sound_stone_defaults()
	)

	stairs.register_stair_and_slab(
		"adobe_brick",
		"swaz_brick_wall",
		{cracky = 2, stone = 1},
		{"swaz_brick_wall.png"},
		S("Bricked Stair"),
		S("Bricked Slab"),
		default.node_sound_stone_defaults()
	)
end

--Farming Support

if minetest.get_modpath("farming")~=nil then

	minetest.override_item("swaz:silt_with_grass", {
		soil = {
			base = "default:silt_with_grass",
			dry = "swaz:soil",
			wet = "swaz:soil_wet"
		}
	})

	minetest.register_node("swaz:soil", {
		description = S("Soil"),
		tiles = {"swaz_silt.png^farming_soil.png", "swaz_silt.png"},
		drop = "swaz:silt",
		groups = {crumbly=3, not_in_creative_inventory=1, soil=2, grassland = 1, field = 1},
		sounds = default.node_sound_dirt_defaults(),
		soil = {
			base = "swaz:silt",
			dry = "swaz:soil",
			wet = "swaz:soil_wet"
		}
	})

	minetest.register_node("swaz:soil_wet", {
		description = S("Wet Soil"),
		tiles = {"swaz_silt.png^farming_soil_wet.png", "swaz_silt.png"},
		drop = "swaz:silt",
		groups = {crumbly=3, not_in_creative_inventory=1, soil=3, wet = 1, grassland = 1, field = 1},
		sounds = default.node_sound_dirt_defaults(),
		soil = {
			base = "swaz:silt",
			dry = "swaz:soil",
			wet = "swaz:soil_wet"
		}
	})
end


if minetest.get_modpath("bucket")~=nil then
	bucket.register_liquid(
		"swaz:water_source",
		"swaz:water_flowing",
		"swaz:bucket_swampy_water",
		"swaz_swampy_water.png",
		S("Swampy Water Bucket"),
		{tool = 1, water_bucket = 1},
		true
	)
end
