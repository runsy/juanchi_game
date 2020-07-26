-- internationalization boleoerplate
local S = minetest.get_translator(minetest.get_current_modname())

local function register_liquid(name, desc, over1, over2)
	local texture = name:gsub("%:", "_")

	local water_sounds = default and default.node_sound_water_defaults()

	minetest.register_node(name .. "_source", {
		description = desc,
		drawtype = "liquid",
		tiles = {
			{
				name = texture .. "_source_animated.png",
				backface_culling = false,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 2.0,
				},
			},
			{
				name = texture .. "_source_animated.png",
				backface_culling = true,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 2.0,
				},
			},
		},
		alpha = 250,
		paramtype = "light",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		drop = "",
		drowning = 1,
		liquidtype = "source",
		liquid_alternative_flowing = name .. "_flowing",
		liquid_alternative_source = name .. "_source",
		liquid_viscosity = 7,
		liquid_range = 2,
		post_effect_color = {a = 153, r = 30, g = 30, b = 30},
		groups = {liquid = 3, oil = 1},
		sounds = water_sounds,
	})

	minetest.register_node(name .. "_flowing", {
		description = S("Flowing").." ".. desc,
		drawtype = "flowingliquid",
		tiles = {texture .. ".png"},
		special_tiles = {
			{
				name = texture .. "_flowing_animated.png",
				backface_culling = false,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 0.8,
				},
			},
			{
				name = texture .. "_flowing_animated.png",
				backface_culling = true,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 0.8,
				},
			},
		},
		alpha = 250,
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
		liquid_alternative_flowing = name .. "_flowing",
		liquid_alternative_source = name .. "_source",
		liquid_viscosity = 7,
		liquid_range = 2,
		post_effect_color = {a = 250, r = 0, g = 0, b = 0},
		groups = {liquid = 3, not_in_creative_inventory = 1},
		sounds = water_sounds,
	})

	minetest.override_item(name .. "_source",  table.copy(over1))
	minetest.override_item(name .. "_flowing",  table.copy(over1))
	if over2 then
		minetest.override_item(name .. "_flowing", table.copy(over2))
	end

	if minetest.get_modpath("bucket") then
		bucket.register_liquid(name .. "_source", name .. "_flowing",
			name .. "_bucket", texture .. "_bucket.png", desc .." ".. S("Bucket"))
	end
end

local oleo_sounds = {footstep = {name = "oleo_oleo_footstep", gain = 0.2}}

register_liquid("oleo:crude", S("Crude Oil"), {
	liquid_viscosity = 7,
	liquid_range = 2,
	post_effect_color = {a = 250, r = 0, g = 0, b = 0},
	sounds = oleo_sounds,
})

register_liquid("oleo:naphtha", S("Naphtha"), {
	liquid_viscosity = 7,
	liquid_range = 2,
	post_effect_color = {a = 250, r = 0, g = 0, b = 0},
	sounds = oleo_sounds,
})

if minetest.get_modpath("default") then
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "oleo:crude_source",
		wherein         = {"default:stone"},
		clust_scarcity  = 64 * 64 * 64,
		clust_size      = 5,
		y_max           = -20,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset  = 0.5,
			scale   = 0.2,
			spread  = {x = 5, y = 5, z = 5},
			seed    = 2316,
			octaves = 1,
			persist = 0.0
		},
		biomes = {
			"taiga_ocean",
			"snowy_grassland_ocean",
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean",
			"sandstone_desert_ocean",
			"cold_desert_ocean",
		},
	})
else
	minetest.log("warning", "[ore] Unable to find biomes to spawn ore in!")
end
