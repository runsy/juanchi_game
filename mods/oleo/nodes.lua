-- internationalization boleoerplate
local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_node("oleo:asphalt", {
    description = S("Asphalt"),
    tiles = {"oleo_asphalt.png"},
    is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	type   = "shapeless",
	output = "oleo:asphalt",
	recipe = {"oleo:crude_bucket", "default:sand"},
	replacements = {{"oleo:crude_bucket", "bucket:bucket_empty"}},
})

minetest.register_node("oleo:oil_drum", {
    description = S("Oil Drum"),
    tiles = {
		"oleo_drum_top.png",
		"oleo_drum_bottom.png",
		"oleo_drum_side.png",
		"oleo_drum_side.png",
		"oleo_drum_side.png",
		"oleo_drum_side.png",
    },
    is_ground_content = false,
	groups = {cracky = 2, oil = 1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	type   = "shaped",
	output = "oleo:oil_drum",
	recipe = {
		{"oleo:crude_bucket", "oleo:crude_bucket", "oleo:crude_bucket"},
		{"oleo:crude_bucket", "", "oleo:crude_bucket"},
		{"oleo:crude_bucket", "oleo:crude_bucket", "oleo:crude_bucket"}
	},
})
