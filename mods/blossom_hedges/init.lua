-- Blossom Hedges

local S = minetest.get_translator(minetest.get_current_modname())

local hedges = {
	{
		"white_blue",
		S("White & Blue"),
		{"flowers:dandelion_white", "flowers:geranium"}
	},
	{
		"violet_blue",
		S("Violet & Blue"),
		{"flowers:viola", "flowers:geranium"}
	},
	{
		"red_pink",
		S("Red & Pink"),
		{"default:rose_bush", "flowers:geranium"}
	},
	{
		"yellow_orange",
		S("Yellow & Orange"),
		{"flowers:dandelion_yellow", "flowers:gerbera_daisy"}
	}
}

local function add_hedge(name, desc, recipe_items)

	local node_name = "blossom_hedges:" .. name.."".."hedge"

	local drop_items = recipe_items

	recipe_items[#recipe_items+1] = "group:leaves"

	minetest.register_node(node_name, {
		description = S("@1 Hedge", desc),
		drawtype = "allfaces_optional",
		tiles = {"flowers_" .. name .. "_hedge" .. ".png"},
		wield_image =  "flowers_" .. name .. "_hedge" .. ".png",
		sunlight_propagates = true,
		paramtype = "light",
		is_ground_content = false,
		groups = {snappy = 3, flammable = 2, flower = 1, flora = 1},
		sounds = default.node_sound_leaves_defaults(),
		drop = {
			max_items = 1,
			items = {
					{
					items = drop_items,
					rarity = 1,
					inherit_color = true,
					}
			}
		}
    })

	minetest.register_craft({
		output = node_name,
		type = "shapeless",
		recipe = recipe_items,
	})

end

for _,item in pairs(hedges) do
	add_hedge(unpack(item))
end

