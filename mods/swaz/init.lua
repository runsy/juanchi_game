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
	node_water_top = "swaz:water_source",
	depth_water_top = 1,
	node_stone = "swaz:limestone",
	y_max = 25,
	y_min = 1,
	heat_point = 80,
	humidity_point = 89,
})

minetest.register_biome({
	name = "swampz_shore",
	node_top = "default:dirt",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 3,
	node_riverbed = "default:sand",
	depth_riverbed = 2,
	node_water_top = "swaz:water_source",
	depth_water_top = 1,
	y_max = 0,
	y_min = -1,
	heat_point = 60,
	humidity_point = 68,
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
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
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
	alpha = 191,
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
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
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
	alpha = 191,
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
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
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
		place_offset_y = 0,
		schematic = {
			size = {x = 4, y = 1, z = 4},
			data = {
				{name = "swaz:silt_with_grass"}, {name = "swaz:silt_with_grass"}, {name = "swaz:silt_with_grass"},{name = "swaz:silt_with_grass"},
				{name = "swaz:silt_with_grass"}, {name = "swaz:water_source"}, {name = "swaz:water_source"},{name = "swaz:silt_with_grass"},
				{name = "swaz:silt_with_grass"}, {name = "swaz:water_source"}, {name = "swaz:water_source"},{name = "swaz:silt_with_grass"},
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
		num_spawn_by = 4,
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
