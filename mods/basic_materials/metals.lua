-- Translation support
local S = minetest.get_translator("basic_materials")

-- items

minetest.register_craftitem("basic_materials:steel_wire", {
	description = S("Spool of steel wire"),
	inventory_image = "basic_materials_steel_wire.png"
})

minetest.register_craftitem("basic_materials:copper_wire", {
	description = S("Spool of copper wire"),
	inventory_image = "basic_materials_copper_wire.png"
})

minetest.register_craftitem("basic_materials:silver_wire", {
	description = S("Spool of silver wire"),
	inventory_image = "basic_materials_silver_wire.png"
})

minetest.register_craftitem("basic_materials:gold_wire", {
	description = S("Spool of gold wire"),
	inventory_image = "basic_materials_gold_wire.png"
})

minetest.register_craftitem("basic_materials:steel_strip", {
	description = S("Steel Strip"),
	inventory_image = "basic_materials_steel_strip.png"
})

minetest.register_craftitem("basic_materials:copper_strip", {
	description = S("Copper Strip"),
	inventory_image = "basic_materials_copper_strip.png"
})

minetest.register_craftitem("basic_materials:steel_bar", {
	description = S("Steel Bar"),
	inventory_image = "basic_materials_steel_bar.png",
})

minetest.register_craftitem("basic_materials:chainlink_brass", {
	description = S("Chainlinks (brass)"),
	inventory_image = "basic_materials_chainlink_brass.png"
})

minetest.register_craftitem("basic_materials:chainlink_steel", {
	description = S("Chainlinks (steel)"),
	inventory_image = "basic_materials_chainlink_steel.png"
})

minetest.register_craftitem("basic_materials:brass_ingot", {
	description = S("Brass Ingot"),
	inventory_image = "basic_materials_brass_ingot.png",
})

minetest.register_craftitem("basic_materials:gear_steel", {
	description = S("Steel gear"),
	inventory_image = "basic_materials_gear_steel.png"
})

minetest.register_craftitem("basic_materials:padlock", {
	description = S("Padlock"),
	inventory_image = "basic_materials_padlock.png"
})

-- nodes

local chains_node_box = {
		type = "fixed",
		fixed = {
{0, 0.4375, -0.0625, 0.0625, 0.5, -1.11759e-08}, -- NodeBox1
			{0, 0.3125, -0.1875, 0.0625, 0.375, -0.125}, -- NodeBox2
			{0, 0.3125, 0.0625, 0.0625, 0.375, 0.125}, -- NodeBox3
			{0, -0.0625, -0.0625, 0.0625, -7.45058e-09, 3.72529e-09}, -- NodeBox4
			{0, 0.375, -0.125, 0.0625, 0.4375, -0.0625}, -- NodeBox5
			{0, 0.375, 0, 0.0625, 0.4375, 0.0625}, -- NodeBox6
			{0, 0, -0.125, 0.0625, 0.0625, -0.0625}, -- NodeBox7
			{0, 0, 0, 0.0625, 0.0625, 0.0625}, -- NodeBox8
			{0.0625, 0.25, -0.0625, -7.45058e-09, 0.1875, 9.31323e-09}, -- NodeBox9
			{0, -0.125, -0.125, 0.0625, -0.0625, -0.0624999}, -- NodeBox38
			{0, -0.125, 0, 0.0625, -0.0625, 0.0625}, -- NodeBox41
			{0, -0.1875, 0.0625, 0.0625, -0.125, 0.125}, -- NodeBox42
			{0, -0.5, 0, 0.0625, -0.4375, 0.0625}, -- NodeBox45
			{0, -0.5, -0.125, 0.0624999, -0.4375, -0.0625}, -- NodeBox46
			{0, -0.3125, -0.0625, 0.0625, -0.25, 7.45058e-09}, -- NodeBox48
			{-0.0625, 0.125, -0.0625, 2.6077e-08, 0.1875, -3.35276e-08}, -- NodeBox49
			{0.0625, 0.125, -0.0625, 0.125, 0.1875, -3.72529e-09}, -- NodeBox50
			{-0.125, 0.0625, -0.0625, -0.0625, 0.125, 5.58794e-09}, -- NodeBox51
			{0.125, 0.0625, -0.0625, 0.1875, 0.125, -5.58794e-09}, -- NodeBox52
			{-0.0625, -0.25, -0.0625, -3.35276e-08, -0.1875, 3.72529e-09}, -- NodeBox53
			{0.0625, -0.375, -0.0625, 0.125, -0.3125, 5.58794e-09}, -- NodeBox54
			{0.125, -0.4375, -0.0625, 0.1875, -0.375, -7.45058e-09}, -- NodeBox55
			{-0.0625, -0.375, -0.0625, 3.72529e-09, -0.3125, 3.72529e-09}, -- NodeBox56
			{-0.125, -0.4375, -0.0625, -0.0625, -0.375, 3.72529e-09}, -- NodeBox57
			{0.0625, -0.25, -0.0625, 0.125, -0.1875, 3.72529e-09}, -- NodeBox58
			{-0.0625, 0.25, -0.0625, -5.02914e-08, 0.3125, 3.72529e-09}, -- NodeBox59
			{0.0625, 0.25, -0.0625, 0.125, 0.3125, -9.31323e-09}, -- NodeBox60
			{0.1875, 0.375, -0.0625, 0.25, 0.5, -5.58794e-09}, -- NodeBox61
			{-0.1875, 0.375, -0.0625, -0.125, 0.5, 5.58794e-09}, -- NodeBox62
			{0, 0.125, -0.25, 0.0625, 0.3125, -0.1875}, -- NodeBox31
			{0, 0.0625, -0.1875, 0.0625, 0.125, -0.125}, -- NodeBox32
			{0, 0.125, 0.125, 0.0625, 0.3125, 0.1875}, -- NodeBox33
			{0, 0.0625, 0.0625, 0.0625, 0.125, 0.125}, -- NodeBox34
			{-0.1875, -0.125, -0.0625, -0.125, 0.0625, 0}, -- NodeBox35
			{0.1875, -0.125, -0.0625, 0.25, 0.0625, 0}, -- NodeBox36
			{-0.125, -0.1875, -0.0625, -0.0625, -0.125, 0}, -- NodeBox37
			{0.125, -0.1875, -0.0625, 0.1875, -0.125, 0}, -- NodeBox38
			{-0.125, 0.3125, -0.0625, -0.0625, 0.375, 0}, -- NodeBox40
			{0.125, 0.3125, -0.0625, 0.1875, 0.375, 0}, -- NodeBox41
			{0, -0.1875, -0.1875, 0.0625, -0.125, -0.125}, -- NodeBox42
			{0, -0.375, -0.25, 0.0625, -0.1875, -0.1875}, -- NodeBox43
			{0, -0.375, 0.125, 0.0625, -0.1875, 0.1875}, -- NodeBox44
			{0, -0.4375, -0.1875, 0.0625, -0.375, -0.125}, -- NodeBox45
			{0, -0.375, 0.0625, 0.0625, -0.4375, 0.125}, -- NodeBox46
			{-0.1875, -0.5, -0.0625, -0.125, -0.4375, 2.23517e-08}, -- NodeBox45
			{0.1875, -0.5, -0.0625, 0.25, -0.4375, 0}, -- NodeBox46
		}
	}

minetest.register_node("basic_materials:chain_steel", {
	description = S("Chain (steel, hanging)"),
	drawtype = "nodebox",
	node_box = chains_node_box,
	tiles = {"basic_materials_chain_steel.png"},
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	paramtype = "light",
	inventory_image = "basic_materials_chain_steel_inv.png",
	groups = {cracky=3},
	selection_box = chains_sbox,
})

minetest.register_node("basic_materials:chain_brass", {
	description = S("Chain (brass, hanging)"),
	drawtype = "nodebox",
	node_box = chains_node_box,
	tiles = {"basic_materials_chain_brass.png"},
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	paramtype = "light",
	inventory_image = "basic_materials_chain_brass_inv.png",
	groups = {cracky=3},
	selection_box = chains_sbox,
})

minetest.register_node("basic_materials:brass_block", {
	description = S("Brass Block"),
	tiles = {"basic_materials_brass_block.png"},
	is_ground_content = false,
	groups = {cracky=1, level=2},
	sounds = default.node_sound_metal_defaults()
})

-- crafts

minetest.register_craft( {
	output = "basic_materials:copper_wire 2",
	type = "shapeless",
	recipe = {
		"default:copper_ingot",
		"basic_materials:empty_spool",
		"basic_materials:empty_spool",
	},
})

minetest.register_craft( {
	output = "basic_materials:silver_wire 2",
	type = "shapeless",
	recipe = {
		"moreores:silver_ingot",
		"basic_materials:empty_spool",
		"basic_materials:empty_spool",
	},
})

minetest.register_craft( {
	output = "basic_materials:gold_wire 2",
	type = "shapeless",
	recipe = {
		"default:gold_ingot",
		"basic_materials:empty_spool",
		"basic_materials:empty_spool",
	},
})

minetest.register_craft( {
	output = "basic_materials:steel_wire 2",
	type = "shapeless",
	recipe = {
		"default:steel_ingot",
		"basic_materials:empty_spool",
		"basic_materials:empty_spool",
	},
})

minetest.register_craft( {
	output = "basic_materials:steel_strip 12",
	recipe = {
		{ "", "default:steel_ingot", "" },
		{ "default:steel_ingot", "", "" },
	},
})

minetest.register_craft( {
	output = "basic_materials:copper_strip 12",
	recipe = {
		{ "", "default:copper_ingot", "" },
		{ "default:copper_ingot", "", "" },
	},
})

minetest.register_craft( {
	output = "basic_materials:steel_bar 6",
	recipe = {
		{ "", "", "default:steel_ingot" },
		{ "", "default:steel_ingot", "" },
		{ "default:steel_ingot", "", "" },
	},
})

minetest.register_craft( {
	output = "basic_materials:padlock 2",
	recipe = {
		{ "basic_materials:steel_bar" },
		{ "default:steel_ingot" },
		{ "default:steel_ingot" },
	},
})

minetest.register_craft({
	output = "basic_materials:chainlink_steel 12",
	recipe = {
		{"", "default:steel_ingot", "default:steel_ingot"},
		{ "default:steel_ingot", "", "default:steel_ingot" },
		{ "default:steel_ingot", "default:steel_ingot", "" },
	},
})

minetest.register_craft({
	output = "basic_materials:chainlink_brass 12",
	recipe = {
		{"", "basic_materials:brass_ingot", "basic_materials:brass_ingot"},
		{ "basic_materials:brass_ingot", "", "basic_materials:brass_ingot" },
		{ "basic_materials:brass_ingot", "basic_materials:brass_ingot", "" },
	},
})

minetest.register_craft({
	output = 'basic_materials:chain_steel 2',
	recipe = {
		{"basic_materials:chainlink_steel"},
		{"basic_materials:chainlink_steel"},
		{"basic_materials:chainlink_steel"}
	}
})

minetest.register_craft({
	output = 'basic_materials:chain_brass 2',
	recipe = {
		{"basic_materials:chainlink_brass"},
		{"basic_materials:chainlink_brass"},
		{"basic_materials:chainlink_brass"}
	}
})

minetest.register_craft( {
	output = "basic_materials:gear_steel 6",
	recipe = {
		{ "", "default:steel_ingot", "" },
		{ "default:steel_ingot","basic_materials:chainlink_steel", "default:steel_ingot" },
		{ "", "default:steel_ingot", "" }
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "basic_materials:brass_ingot 3",
	recipe = {
		"default:copper_ingot",
		"default:copper_ingot",
		"moreores:silver_ingot",
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "basic_materials:brass_ingot 9",
	recipe = { "basic_materials:brass_block" },
})

minetest.register_craft( {
	output = "basic_materials:brass_block",
	recipe = {
		{ "basic_materials:brass_ingot", "basic_materials:brass_ingot", "basic_materials:brass_ingot" },
		{ "basic_materials:brass_ingot", "basic_materials:brass_ingot", "basic_materials:brass_ingot" },
		{ "basic_materials:brass_ingot", "basic_materials:brass_ingot", "basic_materials:brass_ingot" },
	},
})

-- aliases

minetest.register_alias("homedecor:copper_wire",           "basic_materials:copper_wire")
minetest.register_alias("technic:fine_copper_wire",        "basic_materials:copper_wire")
minetest.register_alias("technic:fine_silver_wire",        "basic_materials:silver_wire")
minetest.register_alias("technic:fine_gold_wire",          "basic_materials:gold_wire")

minetest.register_alias("homedecor:steel_wire",            "basic_materials:steel_wire")

minetest.register_alias("homedecor:brass_ingot",           "basic_materials:brass_ingot")
minetest.register_alias("technic:brass_ingot",             "basic_materials:brass_ingot")
minetest.register_alias("technic:brass_block",             "basic_materials:brass_block")

minetest.register_alias("homedecor:copper_strip",          "basic_materials:copper_strip")
minetest.register_alias("homedecor:steel_strip",           "basic_materials:steel_strip")

minetest.register_alias_force("glooptest:chainlink",       "basic_materials:chainlink_steel")
minetest.register_alias_force("homedecor:chainlink_steel", "basic_materials:chainlink_steel")
minetest.register_alias("homedecor:chainlink_brass",       "basic_materials:chainlink_brass")
minetest.register_alias("chains:chain",                    "basic_materials:chain_steel")
minetest.register_alias("chains:chain_brass",              "basic_materials:chain_brass")

minetest.register_alias("pipeworks:gear",                  "basic_materials:gear_steel")

minetest.register_alias("technic:rebar",                  "basic_materials:steel_bar")

