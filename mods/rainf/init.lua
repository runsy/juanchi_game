local S = minetest.get_translator(minetest.get_current_modname())
local mg_name = minetest.get_mapgen_setting("mg_name")


--Variables

local grapes_grow_time = 2250

local water_type
if mg_name == "valleys" then
	water_type= "default:river_water_source"
else
	water_type= "default:water_source"
end

local dirt_type
if minetest.get_modpath("swaz")~=nil then
	dirt_type = "swaz:silt"
else
	dirt_type = "rainf:dirt"
end

-- Register Biomes

minetest.register_biome({
	name = "temperate_rainforest",
	node_top = "rainf:meadow",
	depth_top = 1,
	node_filler = dirt_type,
	depth_filler = 3,
	node_riverbed = "default:sand",
	depth_riverbed = 2,
	node_water_top = water_type,
	depth_water_top = 1,
	node_stone = "rainf:granite",
	y_max = 31000,
	y_min = 1,
	heat_point = 52,
	humidity_point = 75,
})

minetest.register_node("rainf:meadow", {
	description = S("Meadow"),
	tiles = {"rainf_meadow.png", "rainf_dirt.png",
		{name = "rainf_dirt.png^rainf_dirt_with_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "swaz:mud",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_node("rainf:blossom_meadow", {
	description = S("Blossom Meadow"),
	tiles = {"rainf_blossom_meadow.png", "rainf_dirt.png",
		{name = "rainf_dirt.png^rainf_dirt_with_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "swaz:mud",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_node("rainf:meadow_with_mud", {
	description = S("Meadow with Mud"),
	tiles = {"rainf_meadow_with_mud.png", "rainf_dirt.png",
				"rainf_dirt.png"},
	groups = {crumbly = 3},
	drop = "swaz:mud",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_node("rainf:dirt", {
	description = S("Dirt"),
	tiles = {"rainf_dirt.png",},
	groups = {crumbly = 3, soil = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_node("rainf:granite", {
	description = S("Granite"),
	tiles = {"rainf_granite.png"},
	groups = {cracky = 3, stone = 1},
	drop = "rainf:granite",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("rainf:pink_granite", {
	description = S("Pink Granite"),
	tiles = {"rainf_pink_granite.png"},
	groups = {cracky = 3, stone = 1},
	drop = "rainf:pink_granite",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("rainf:pink_granite_with_moss", {
	description = S("Pink Granite with Moss"),
	tiles = {"rainf_pink_granite.png^rainf_moss.png"},
	groups = {cracky = 3, stone = 1},
	drop = "rainf:pink_granite",
	sounds = default.node_sound_stone_defaults(),
})

--Grasses

minetest.register_node("rainf:aloe_vera", {
	description = S("Aloe Vera"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.0,
	tiles = {"rainf_aloe_vera.png"},
	inventory_image = "rainf_aloe_vera.png",
	wield_image = "rainf_aloe_vera.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, -2 / 16, 3 / 16},
	},
})

minetest.register_node("rainf:weed", {
	description = S("Weed"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 0.8,
	tiles = {"rainf_weed.png"},
	inventory_image = "rainf_weed.png",
	wield_image = "rainf_weed.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, -2 / 16, 3 / 16},
	},
})

--Short Grass

minetest.register_node("rainf:grass", {
	description = S("Short Grass"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 0.8,
	tiles = {"rainf_grass.png"},
	inventory_image = "rainf_grass.png",
	wield_image = "rainf_grass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -5 / 16, 4 / 16},
	},
})

--Flowers

minetest.register_node("rainf:pansy", {
	description = S("Pansy"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 0.8,
	tiles = {"rainf_pansy.png"},
	inventory_image = "rainf_pansy.png",
	wield_image = "rainf_pansy.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flower = 1, flora = 1, attached_node = 1, flammable = 1, color_blue = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-2 / 16, -0.5, -2 / 16, 2 / 16, 0, 2 / 16},
	},
})

minetest.register_node("rainf:dahlia", {
	description = S("Dahlia"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 0.8,
	tiles = {"rainf_dahlia.png"},
	inventory_image = "rainf_dahlia.png",
	wield_image = "rainf_dahlia.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flower = 1, flora = 1, attached_node = 1, flammable = 1, color_orange = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-2 / 16, -0.5, -2 / 16, 2 / 16, 0, 2 / 16},
	},
})

minetest.register_node("rainf:camomille", {
	description = S("Camomille"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 0.8,
	tiles = {"rainf_camomille.png"},
	inventory_image = "rainf_camomille.png",
	wield_image = "rainf_camomille.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flower = 1, flora = 1, attached_node = 1, flammable = 1, color_white = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, -6 / 16, 3 / 16},
	},
})

minetest.register_node("rainf:red_daisy", {
	description = S("Red Daisy"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.0,
	tiles = {"rainf_red_daisy.png"},
	inventory_image = "rainf_red_daisy.png",
	wield_image = "rainf_red_daisy.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flower = 1, flora = 1, attached_node = 1, flammable = 1, color_red = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -5 / 16, 4 / 16},
	},
})

minetest.register_node("rainf:hyacinth", {
	description = S("Hyacinth"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.0,
	tiles = {"rainf_hyacinth.png"},
	inventory_image = "rainf_hyacinth.png",
	wield_image = "rainf_hyacinth.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flower = 1, flora = 1, attached_node = 1, flammable = 1, color_yellow = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-2 / 16, -0.5, -2 / 16, 2 / 16, 0, 2 / 16},
	},
})

-- Vines and Grapes

minetest.register_node("rainf:grapes", {
	description = S("Grapes"),
	drawtype = "plantlike",
	tiles = {"rainf_grapes.png"},
	inventory_image = "rainf_grapes.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2, leafdecay = 3, leafdecay_drop = 1},
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = function(pos, placer, itemstack)
		minetest.set_node(pos, {name = "rainf:grapes", param2 = 1})
	end,
})

minetest.register_node("rainf:vine", {
	description = S("Vine"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.0,
	tiles = {"rainf_vine.png"},
	inventory_image = "rainf_vine.png",
	wield_image = "rainf_vine.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1,},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-2 / 16, -0.5, -2 / 16, 2 / 16, 0, 2 / 16},
	},

	on_construct = function(pos)
		--20% of variation on time
		local twenty_percent = grapes_grow_time * 0.2
		local grow_time = math.random(grapes_grow_time - twenty_percent, grapes_grow_time + twenty_percent)
		minetest.get_node_timer(pos):start(grow_time)
	end,

	on_timer = function(pos)
		local node = minetest.get_node_or_nil(pos)
		if node and node.name == "rainf:vine" then
			minetest.set_node(pos, {name = "rainf:grapevine"})
			return false
		end
	end,
})

minetest.register_node("rainf:grapevine", {
	description = S("Grapevine"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.0,
	tiles = {"rainf_grapevine.png"},
	inventory_image = "rainf_grapevine.png",
	wield_image = "rainf_grapevine.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1,},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-2 / 16, -0.5, -2 / 16, 2 / 16, 0, 2 / 16},
	},

	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local inv = player:get_inventory()
		if inv:room_for_item("main", "rainf:grapes") then
			inv:add_item("main", "rainf:grapes")
			minetest.set_node(pos, {name="rainf:vine"})
		end
	end
})

-- Mushroom

minetest.register_node("rainf:champignon", {
	description = S("Champignon"),
	visual_scale = 0.8,
	tiles = {"rainf_champignon.png"},
	inventory_image = "rainf_champignon.png",
	wield_image = "rainf_champignon.png",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	stack_max = 99,
	groups = {snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	on_use = minetest.item_eat(3),
	selection_box = {
		type = "fixed",
		fixed = {-2 / 16, -0.5, -2 / 16, 2 / 16, -3 / 16, 2 / 16},
	}
})

minetest.register_abm({
	label = "Rainf Mushroom Spread",
	nodenames = {"rainf:champignon"},
	interval = 11,
	chance = 150,
	action = function(...)
		flowers.mushroom_spread(...)
	end,
})

--Pavements

local pavements= {
	{name= "rainf:granite_wall", description= "Granite Wall", texture= "rainf_granite_wall.png",
		amount = 8,
		recipe = {
			{'rainf:granite', 'rainf:granite', 'rainf:granite'},
			{'rainf:granite', 'rainf:granite', 'rainf:granite'},
			{'rainf:granite', 'rainf:granite', 'rainf:granite'},
		}
	},
}

for i = 1, #pavements do
	minetest.register_node(pavements[i].name, {
		description = S(pavements[i].description),
		tiles = {pavements[i].texture},
		is_ground_content = true,
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
	})
	local amount
	if pavements[i].amount then
		amount = " ".. tostring(pavements[i].amount)
	else
		amount = "1"
	end
	minetest.register_craft({
		output = pavements[i].name .. amount,
		type = 'shaped',
		recipe = pavements[i].recipe,
	})
end

-- Register Decoration
-- IMPORTANT!
-- THE ORDER OF THE DECORATION MATTERS!
-- DO NOT SORT

if mg_name ~= "v6" and mg_name ~= "singlenode" then

	--Water Source (4x4)

	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"rainf:meadow"},
		sidelen = 16,
		noise_params = {
			offset = 0.0009,
			scale = 0.005,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"rainf"},
		height = 2,
		y_min = 2,
		y_max = 1000,
		place_offset_y = 0,
		schematic = {
			size = {x = 4, y = 1, z = 4},
			data = {
				{name = "rainf:meadow"}, {name = "rainf:meadow"}, {name = "rainf:meadow"},{name = "rainf:meadow"},
				{name = "rainf:meadow"}, {name = water_type}, {name = water_type},{name = "rainf:meadow"},
				{name = "rainf:meadow"}, {name = water_type}, {name = water_type},{name = "rainf:meadow"},
				{name = "rainf:meadow"}, {name = "rainf:meadow"}, {name = "rainf:meadow"},{name = "rainf:meadow"},
			}
		},
		spawn_by = "rainf:meadow",
		num_spawn_by = 5,
		flags = "place_center_x, place_center_z, force_placement",
		rotation = "random",
	})

	minetest.register_decoration({
		decoration = "rainf:blossom_meadow",
		deco_type = "simple",
		place_on = "rainf:meadow",
		sidelen = 16,
		fill_ratio = 0.1,
		biomes = {"rainf"},
		noise_params = {
			offset = 0.0002,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 221,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
		place_offset_y = -1,
		flags = "place_center_x, place_center_z, force_placement",
	})

	minetest.register_decoration({
		decoration = "rainf:meadow_with_mud",
		deco_type = "simple",
		place_on = "rainf:meadow",
		sidelen = 16,
		fill_ratio = 2.0,
		biomes = {"rainf"},
		y_min = 1,
		y_max = 80,
		spawn_by = water_type,
		num_spawn_by = 1,
		place_offset_y = -1,
		flags = "place_center_x, place_center_z, force_placement",
	})

	minetest.register_decoration({
		decoration = "rainf:meadow_with_mud",
		deco_type = "simple",
		place_on = "rainf:meadow",
		sidelen = 16,
		fill_ratio = 0.05,
		noise_params = {
			offset = 0.2,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 451,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"rainf"},
		y_min = 1,
		y_max = 80,
		spawn_by = "rainf:meadow_with_mud",
		num_spawn_by = 1,
		place_offset_y = -1,
		flags = "place_center_x, place_center_z, force_placement",
	})

	minetest.register_decoration({
		deco_type = "simple",
		decoration = water_type,
		place_on = {"rainf:meadow"},
		sidelen = 16,
		noise_params = {
			offset = 0.8,
			scale = 0.8,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"rainf"},
		height = 2,
		y_min = 2,
		y_max = 1000,
		place_offset_y = -2,
		spawn_by = "rainf:meadow_with_mud",
		num_spawn_by = 6,
		flags = "place_center_x, place_center_z, force_placement",
		rotation = "random",
	})

	minetest.register_decoration({
		deco_type = "schematic",
		schematic = {
			size = {x = 1, y = 2, z = 1},
			data = {
				{name = "rainf:pink_granite"}, {name = "rainf:pink_granite_with_moss"},
			}
		},
		place_on = "rainf:meadow",
		sidelen = 16,
		fill_ratio = 0.00001,
		biomes = {"rainf"},
		noise_params = {
			offset = 0.0002,
			scale = 0.0008,
			spread = {x = 250, y = 250, z = 250},
			seed = 4341,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
		place_offset_y = -1,
		flags = "place_center_x, place_center_z, force_placement",
	})

	minetest.register_decoration({
		deco_type = "schematic",
		schematic = {
			size = {x = 1, y = 2, z = 1},
			data = {
				{name = "rainf:pink_granite"}, {name = "rainf:pink_granite_with_moss"},
			}
		},
		place_on = "rainf:meadow",
		sidelen = 16,
		fill_ratio = 0.6,
		biomes = {"rainf"},
		y_min = 1,
		y_max = 80,
		place_offset_y = -1,
		spawn_by = "rainf:pink_granite_with_moss",
		num_spawn_by = 1,
		flags = "place_center_x, place_center_z, force_placement",
	})

	--Another Pink granite over same block

	minetest.register_decoration({
		decoration = "rainf:pink_granite_with_moss",
		deco_type = "simple",
		place_on = "rainf:pink_granite_with_moss",
		sidelen = 16,
		fill_ratio = 0.6,
		biomes = {"rainf"},
		y_min = 1,
		y_max = 80,
		place_offset_y = 0,
		flags = "place_center_x, place_center_z, force_placement",
	})

	minetest.register_decoration({
		decoration = "rainf:blossom_meadow",
		deco_type = "simple",
		place_on = "rainf:meadow",
		sidelen = 16,
		fill_ratio = 0.1,
		biomes = {"rainf"},
		noise_params = {
			offset = 0.9,
			scale = 0.08,
			spread = {x = 250, y = 250, z = 250},
			seed = 2231,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		spawn_by = "rainf:blossom_meadow",
		num_spawn_by = 1,
		place_offset_y = -1,
		y_max = 80,
		flags = "place_center_x, place_center_z, force_placement",
	})

	--Aloe Vera

	minetest.register_decoration({
		decoration = "rainf:aloe_vera",
		deco_type = "simple",
		place_on = {"rainf:meadow"},
		sidelen = 16,
		biomes = {"rainf"},
		fill_ratio = 0.001,
		y_min = 1,
		y_max = 80,
	})

	--Weed

	minetest.register_decoration({
		decoration = "rainf:weed",
		deco_type = "simple",
		place_on = {"rainf:meadow", "rainf:meadow_with_mud", "rainf:pink_granite_with_moss"},
		sidelen = 16,
		biomes = {"rainf"},
		fill_ratio = 0.01,
		y_min = 1,
		y_max = 80,
	})

	minetest.register_decoration({
		decoration = "rainf:grass",
		deco_type = "simple",
		place_on = {"rainf:meadow", "rainf:pink_granite_with_moss"},
		sidelen = 16,
		biomes = {"rainf"},
		fill_ratio = 0.05,
		y_min = 1,
		y_max = 80,
	})

	--Pansy

	minetest.register_decoration({
		decoration = "rainf:pansy",
		deco_type = "simple",
		place_on = "rainf:meadow",
		sidelen = 16,
		fill_ratio = 0.008,
		biomes = {"rainf"},
		noise_params = {
			offset = 0.005,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 289,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
	})

	--Dahlia

	minetest.register_decoration({
		decoration = "rainf:dahlia",
		deco_type = "simple",
		place_on = "rainf:meadow",
		sidelen = 16,
		fill_ratio = 0.008,
		biomes = {"rainf"},
		noise_params = {
			offset = 0.005,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 34,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
	})

	-- Camomille

	minetest.register_decoration({
		decoration = "rainf:camomille",
		deco_type = "simple",
		place_on = "rainf:blossom_meadow",
		sidelen = 16,
		fill_ratio = 0.5,
		biomes = {"rainf"},
		noise_params = {
			offset = 0.8,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 452,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
	})

	-- Red Daisy

	minetest.register_decoration({
		decoration = "rainf:red_daisy",
		deco_type = "simple",
		place_on = "rainf:meadow",
		sidelen = 16,
		fill_ratio = 0.05,
		biomes = {"rainf"},
		noise_params = {
			offset = 0.005,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 452,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
	})

	-- Hyacinth

	minetest.register_decoration({
		decoration = "rainf:hyacinth",
		deco_type = "simple",
		place_on = "rainf:meadow",
		sidelen = 16,
		fill_ratio = 0.05,
		biomes = {"rainf"},
		noise_params = {
			offset = 0.005,
			scale = 0.008,
			spread = {x = 250, y = 250, z = 250},
			seed = 452,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
	})

	-- Champignon

	minetest.register_decoration({
		decoration = "rainf:champignon",
		deco_type = "simple",
		place_on = "rainf:meadow",
		sidelen = 16,
		fill_ratio = 0.0005,
		biomes = {"rainf"},
		noise_params = {
			offset = 0.0008,
			scale = 0.0008,
			spread = {x = 250, y = 250, z = 250},
			seed = 452,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
	})

	-- Vine

	minetest.register_decoration({
		decoration = "rainf:grapevine",
		deco_type = "simple",
		place_on = "rainf:meadow",
		sidelen = 16,
		fill_ratio = 0.0005,
		biomes = {"rainf"},
		noise_params = {
			offset = 0.0008,
			scale = 0.0008,
			spread = {x = 250, y = 250, z = 250},
			seed = 452,
			octaves = 3,
			persist = 0.66
		},
		y_min = 1,
		y_max = 80,
	})

end

if minetest.get_modpath("stairs")~=nil then

	stairs.register_stair_and_slab(
		"granite",
		"rainf:granite",
		{cracky = 2, stone = 1},
		{"rainf_granite.png"},
		S("Granite Stair"),
		S("Granite Slab"),
		default.node_sound_stone_defaults()
	)

	stairs.register_stair_and_slab(
		"pink_granite",
		"rainf:pink_granite",
		{cracky = 2, stone = 1},
		{"rainf_pink_granite.png"},
		S("Pink Granite Stair"),
		S("Pink Granite Slab"),
		default.node_sound_stone_defaults()
	)
end

--Farming Support

if minetest.get_modpath("farming")~=nil then

	minetest.override_item("rainf:meadow", {
		soil = {
			base = "rainf:meadow",
			dry = "rainf:soil",
			wet = "rainf:soil_wet"
		}
	})

	minetest.override_item("rainf:blossom_meadow", {
		soil = {
			base = "rainf:blossom_meadow",
			dry = "rainf:soil",
			wet = "rainf:soil_wet"
		}
	})

	minetest.register_node("rainf:soil", {
		description = S("Soil"),
		tiles = {"rainf_dirt.png^farming_soil.png", "rainf_dirt.png"},
		drop = "rainf:dirt",
		groups = {crumbly=3, not_in_creative_inventory=1, soil=2, grassland = 1, field = 1},
		sounds = default.node_sound_dirt_defaults(),
		soil = {
			base = "rainf:dirt",
			dry = "rainf:soil",
			wet = "rainf:soil_wet"
		}
	})

	minetest.register_node("rainf:soil_wet", {
		description = S("Wet Soil"),
		tiles = {"rainf_dirt.png^farming_soil_wet.png", "rainf_dirt.png"},
		drop = "rainf:dirt",
		groups = {crumbly=3, not_in_creative_inventory=1, soil=3, wet = 1, grassland = 1, field = 1},
		sounds = default.node_sound_dirt_defaults(),
		soil = {
			base = "rainf:dirt",
			dry = "rainf:soil",
			wet = "rainf:soil_wet"
		}
	})
end
