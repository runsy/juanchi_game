--
-- register crafting recipes:
--

if minetest.registered_items["homedecor:paraffin"]
and minetest.registered_items["farming:cotton"] then
	minetest.register_craft({
		output = "lantern:candle 12",
		recipe = {
			{"homedecor:paraffin", "farming:cotton", "homedecor:paraffin"},
			{"homedecor:paraffin", "farming:cotton", "homedecor:paraffin"},
			{"homedecor:paraffin", "farming:cotton", "homedecor:paraffin"},
		}
	})
else
	minetest.register_craft({
		output = "lantern:candle 12",
		recipe = {
			{"default:coal_lump","default:coal_lump"},
			{"group:stick","group:stick"},
		}
	})
end

minetest.register_craft({
	output = "lantern:lantern 4",
	recipe = {
		{"","group:stick",""},
		{"group:stick","lantern:candle","group:stick"},
		{"","group:stick",""},
	}
})

minetest.register_craft({
	output = "lantern:lantern 4",
	recipe = {
		{"group:stick","","group:stick"},
		{"","lantern:candle",""},
		{"group:stick","","group:stick"},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "lantern:fence_black",
	recipe = {"default:coal_lump", "default:fence_wood"},
})

minetest.register_craft({
	output = "lantern:lamp 4",
	recipe = {
		{"","default:steel_ingot",""},
		{"default:steel_ingot","lantern:candle","default:steel_ingot"},
		{"","default:steel_ingot",""},
	}
})

minetest.register_craft({
	output = "lantern:lamp 4",
	recipe = {
		{"default:steel_ingot","","default:steel_ingot"},
		{"","lantern:candle",""},
		{"default:steel_ingot","","default:steel_ingot"},
	}
})

minetest.register_craft({
	output = "lantern:lamp_post",
	recipe = {
		{"lantern:fence_black", "lantern:fence_black"},
		{"lantern:fence_black", "lantern:lamp"},
		{"lantern:fence_black", ""},
	}
})
