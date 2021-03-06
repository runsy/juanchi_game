screwdriver = screwdriver or {}

--dofile(minetest.get_modpath("lapis").."/columns.lua")

local S = minetest.get_translator(minetest.get_current_modname())

----------
--Nodes
----------

minetest.register_node("lapis:lapis_block",  {
   description = S("Lapis with Calcite"),
   tiles = {"lapis_block.png"},
   paramtype = "light",
   is_ground_content = true,
   groups = {cracky = 3},
   drop = {
		max_items = 1,
		items = {
			{items = {'lapis:lapis_stone'}, rarity = 10},
			{items = {'lapis:lapis_cobble'}},
		},
	},
   sounds = default.node_sound_stone_defaults()
})

minetest.register_node("lapis:lapis_brick",  {
   description = S("Lapis Brick"),
   tiles = {
   "lapis_brick_top.png",
   "lapis_brick_top.png^[transformFXR90",
   "lapis_brick_side.png",
   "lapis_brick_side.png^[transformFX",
   "lapis_brick.png^[transformFX",
   "lapis_brick.png"
   },
   paramtype = "light",
   paramtype2 = "facedir",
   place_param2 = 0,
   on_rotate = screwdriver.rotate_simple,
   is_ground_content = false,
   groups = {cracky = 3},
   sounds = default.node_sound_stone_defaults()
})

minetest.register_node("lapis:lapis_cobble",  {
   description = S("Cobbled Lapis"),
   tiles = {
   "lapis_cobble.png",
   "lapis_cobble.png^[transformFY",
   "lapis_cobble.png^[transformFX",
   "lapis_cobble.png",
   "lapis_cobble.png^[transformFX",
   "lapis_cobble.png"
   },
   paramtype = "light",
   is_ground_content = false,
   groups = {cracky = 3},
   sounds = default.node_sound_stone_defaults()
})

minetest.register_node( "lapis:lazurite_block",  {
   description = S("Lazurite"),
   tiles = {"lapis_lazurite_block.png"},
   paramtype = "light",
   is_ground_content = true,
   groups = {cracky = 3},
   sounds = default.node_sound_stone_defaults()
})

minetest.register_node( "lapis:lazurite_brick",  {
   description = S("Lazurite Brick"),
   tiles = {
   "lapis_lazurite_brick_top.png",
   "lapis_lazurite_brick_top.png^[transformFXR90",
   "lapis_lazurite_brick_side.png",
   "lapis_lazurite_brick_side.png^[transformFX",
   "lapis_lazurite_brick.png^[transformFX",
   "lapis_lazurite_brick.png"
   },
   paramtype = "light",
   paramtype2 = "facedir",
   place_param2 = 0,
   on_rotate = screwdriver.rotate_simple,
   is_ground_content = false,
   groups = {cracky = 3},
   sounds = default.node_sound_stone_defaults()
})

minetest.register_node( "lapis:lapis_tile",  {
   description = S("Lapis Floor Tile"),
   tiles = {"lapis_tile.png" },
   is_ground_content = false,
   paramtype = 'light',
   groups = {cracky = 3},
   sounds = default.node_sound_stone_defaults()
   })

minetest.register_node( "lapis:pyrite_ore",  {
   description = S("Pyrite Ore"),
   tiles = {"default_stone.png^lapis_mineral_pyrite.png" },
   paramtype = "light",
   is_ground_content = true,
   drop= 'lapis:pyrite_lump 2',
   groups = {cracky = 2},
   sounds = default.node_sound_stone_defaults() ,
})

minetest.register_node( "lapis:pyrite_block",  {
   description = S("Pyrite Block"),
   tiles = {
   "lapis_pyrite_sacred.png",
   "lapis_pyrite_sacred.png",
   "lapis_pyrite_block.png"
   },
   paramtype = "light",
   paramtype2 = "facedir",
   place_param2 = 0,
   is_ground_content = false,
   groups = {cracky = 2},
   sounds = default.node_sound_metal_defaults({
     footstep = {name = "default_hard_footstep", gain = 0.5},
     place = {name = "default_place_node_hard", gain = 1.0},
   }),
})
--Unused Rosace Stone from Darkage mod
minetest.register_node("lapis:rosace", {
	description = S("Rose Stone"),
	tiles = {"lapis_rosace_front.png",
	"lapis_rosace_front.png",
	"lapis_rosace_side.png^[transformFX",
	"lapis_rosace_side.png^[transformFYR90",
	"lapis_rosace_side.png^[transformFY",
	"lapis_rosace_side.png"},
	paramtype2 = "facedir",
	place_param2 = 0,
	is_ground_content = false,
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_stone_defaults(),
})

-------------------
--Stairs & Slabs
-------------------
-- Add support for Stairs Plus (in More Blocks), by Worldblender
	if minetest.get_modpath("moreblocks") then

	stairsplus:register_all("lapis", "lapis_block", "lapis:lapis_block", {
	description = S("Lapis with Calcite"),
	tiles = {"lapis_block.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("lapis", "lapis_brick", "lapis:lapis_brick", {
	description = S("Lapis Brick"),
	tiles = {"lapis_brick_top.png",
   "lapis_brick_top.png^[transformFXR90",
   "lapis_brick_side.png",
   "lapis_brick_side.png^[transformFX",
   "lapis_brick.png^[transformFX",
   "lapis_brick.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("lapis", "lapis_cobble", "lapis:lapis_cobble", {
	description = S("Cobbled Lapis"),
	tiles = {"lapis_cobble.png",
   "lapis_cobble.png^[transformFY",
   "lapis_cobble.png^[transformFX",
   "lapis_cobble.png",
   "lapis_cobble.png^[transformFX",
   "lapis_cobble.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("lapis", "lapis_lazurite_block", "lapis:lazurite_block", {
	description = S("Lazurite"),
	tiles = {"lapis_lazurite_block.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("lapis", "lapis_lazurite_brick", "lapis:lazurite_brick", {
	description = S("Lazurite Brick"),
	tiles = {"lapis_lazurite_brick_top.png",
   "lapis_lazurite_brick_top.png^[transformFXR90",
   "lapis_lazurite_brick_side.png",
   "lapis_lazurite_brick_side.png^[transformFX",
   "lapis_lazurite_brick.png^[transformFX",
   "lapis_lazurite_brick.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("lapis", "lapis_tile", "lapis:lapis_tile", {
	description = S("Lapis Floor Tile"),
	tiles = {"lapis_tile.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("lapis", "pyrite_block", "lapis:pyrite_block", {
	description = S("Pyrite Block"),
	tiles = {"lapis_pyrite_block.png"},
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults({
     footstep = {name = "default_hard_footstep", gain = 0.5},
     place = {name = "default_place_node_hard", gain = 1.0}}),
	})

-- Fall back to default stairs if moreblocks is not installed or enabled
	elseif minetest.get_modpath("stairs") then

	stairs.register_stair_and_slab("lapis_block", "lapis:lapis_block",
	{cracky = 3},
	{"lapis_block.png"},
	S("Lapis Stair"),
	S("Lapis Slab"),
	default.node_sound_stone_defaults())

	stairs.register_stair_and_slab("lapis_brick", "lapis:lapis_brick",
	{cracky = 3},
	{"lapis_brick.png"},
	S("Lapis Brick Stair"),
	S("Lapis Brick Slab"),
	default.node_sound_stone_defaults())

	stairs.register_stair_and_slab("lapis_cobble", "lapis:lapis_cobble",
	{cracky = 3},
	{"lapis_cobble.png"},
	S("Lapis Cobble Stair"),
	S("Lapis Cobble Slab"),
	default.node_sound_stone_defaults())

	stairs.register_stair_and_slab("lazurite", "lapis:lazurite_block",
	{cracky = 3},
	{"lapis_lazurite_block.png"},
	S("Lazurite Stair"),
	S("Lazurite Slab"),
	default.node_sound_stone_defaults())

	stairs.register_stair_and_slab("lazurite_brick", "lapis:lazurite_brick",
	{cracky = 3},
	{"lapis_lazurite_brick.png"},
	S("Lazurite Brick Stair"),
	S("Lazurite Brick Slab"),
	default.node_sound_stone_defaults())
	end

---------------
-- Crafts Items
---------------

minetest.register_craftitem("lapis:lapis_stone", {
	description = S("Lapis Gemstone"),
	inventory_image = "lapis_stone.png",
})

minetest.register_craftitem("lapis:pyrite_ingot", {
	description = S("Pyrite Ingot"),
	inventory_image = "lapis_pyrite_ingot.png",
})

minetest.register_craftitem("lapis:pyrite_lump", {
	description = S("Fool's Gold"),
	inventory_image = "lapis_pyrite_nugget.png",
})

----------
-- Crafts
----------

minetest.register_craft({
	output = 'lapis:lazurite_block',
	recipe = {
		{'lapis:lapis_stone', 'lapis:lapis_stone', 'lapis:lapis_stone'},
		{'lapis:lapis_stone', 'lapis:pyrite_lump', 'lapis:lapis_stone'},
		{'lapis:lapis_stone', 'lapis:lapis_stone', 'lapis:lapis_stone'},
	}
})

minetest.register_craft({
	output = 'lapis:lapis_stone 9',
	recipe = {
		{'lapis:lapis_block'},
	}
})

minetest.register_craft({
	output = 'lapis:lapis_brick 4',
	recipe = {
		{ 'lapis:lapis_block', 'lapis:lapis_block'},
		{ 'lapis:lapis_block', 'lapis:lapis_block'},
	}
})

minetest.register_craft({
	output = 'lapis:lazurite_brick 4',
	recipe = {
		{ '', 'lapis:lapis_brick', ''},
		{ 'lapis:lapis_brick', 'lapis:pyrite_lump', 'lapis:lapis_brick'},
		{ '', 'lapis:lapis_brick', ''},
	}
})

minetest.register_craft({
	output = 'lapis:lapis_tile 2',
	recipe = {
		{ 'lapis:lazurite_brick'},
	}
})

minetest.register_craft({
	output = 'lapis:pyrite_block',
	recipe = {
		{'lapis:pyrite_ingot', 'lapis:pyrite_ingot', 'lapis:pyrite_ingot'},
		{'lapis:pyrite_ingot', 'lapis:pyrite_ingot', 'lapis:pyrite_ingot'},
		{'lapis:pyrite_ingot', 'lapis:pyrite_ingot', 'lapis:pyrite_ingot'},
	}
})

minetest.register_craft({
	output = 'lapis:pyrite_ingot 6',
	recipe = {
		{'lapis:pyrite_block'},
	}
})

minetest.register_craft({
	output = "lapis:rosace_stone 4",
	recipe = {
		{ "lapis:pyrite_ingot", "lapis:lapis_stone", "lapis:pyrite_ingot" },
		{ "lapis:lapis_stone", "lapis:pyrite_ingot", "lapis:lapis_stone" },
		{ "lapis:pyrite_ingot", "lapis:lapis_stone", "lapis:pyrite_ingot" },
	}
})

minetest.register_craft({
	output = 'dye:blue 2',
	recipe = {
		{'lapis:lapis_stone'},
	}
})

------------
-- Cooking
------------

minetest.register_craft({
	type = 'cooking',
	output = 'lapis:lapis_block',
	recipe = 'lapis:lapis_cobble',
})

minetest.register_craft({
	type = "cooking",
	output = "lapis:pyrite_ingot",
	recipe = "lapis:pyrite_lump",
})

--------------------
-- Ore Generation
--------------------

--lapis
--Sheet ore registration
minetest.register_ore({
		ore_type = "sheet",
		ore = "lapis:lapis_block",
		wherein = "default:stone",
		column_height_min = 1,
		column_height_max = 3,
		column_midpoint_factor = 0.5,
		y_min = -500,
		y_max = -20,
		noise_threshhold = 1.25,
		noise_params = {offset=0, scale=2, spread={x=20, y=20, z=10}, seed= 10 , octaves=2, persist=0.8}
	})

-- pyrite
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "lapis:pyrite_ore",
		wherein      = "default:stone",
		clust_scarcity = 24 * 24 * 24,
		clust_num_ores = 4,
		clust_size     = 3,
		y_min          = -50,
		y_max          = -10,
	})

			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "lapis:pyrite_ore",
		wherein        = "default:stone",
		clust_scarcity = 18 * 18 * 18,
		clust_num_ores = 4,
		clust_size     = 3,
		y_min          = -150,
		y_max          = -51,
	})

----------
--Aliases
----------

minetest.register_alias("lapis:lapis_paver", "lapis:lapis_cobble")
minetest.register_alias("lapis:lazurite", "lapis:lapis_block")
minetest.register_alias("lapis:pyrite_sacred","lapis:pyrite_block")
minetest.register_alias("lapis:pyrite_coin","lapis:pyrite_ingot")
minetest.register_alias("lapis:sacred_ore", "lapis:lazurite_block")
