-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_node("nuclearz:stone_with_uranium", {
	description = S("Uranium Ore"),
	light_source = 5,
	tiles = {"default_stone.png^nuclearz_mineral_uranium.png"},
	groups = {cracky = 2},
	drop = "nuclearz:uranium_lump 6",
	sounds = default.node_sound_stone_defaults(),
})

function default.register_ores()
	minetest.register_ore({
		ore_type = "scatter",
		ore = "nuclearz:stone_with_uranium",
		wherein = "default:stone",
		clust_scarcity = 25 * 25 * 25,
		clust_num_ores = 3,
		clust_size = 3,
		y_max = -384,
		y_min = -512,
	})
end

minetest.register_craftitem("nuclearz:uranium_lump", {
	description = S("Uranium Lump"),
	inventory_image = "nuclearz_uranium_lump.png"
})

minetest.register_craftitem("nuclearz:uranium_rod", {
	description = S("Uranium Rod"),
	inventory_image = "nuclearz_uranium_rod.png"
})

minetest.register_craft({
	output = "nuclearz:uranium_rod",
	recipe = {
		{"", "", ""},
		{"", "", ""},
		{"nuclearz:uranium_lump", "nuclearz:uranium_lump", "nuclearz:uranium_lump"},
	}
})
