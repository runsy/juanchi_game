-- internationalization boleoerplate
local S = minetest.get_translator(minetest.get_current_modname())

if minetest.get_modpath("basic_materials") then
	minetest.register_alias("oleo:plastic_sheet", "basic_materials:plastic_sheet")
	minetest.register_alias("oleo:plastic_strip", "basic_materials:plastic_strip")

	minetest.clear_craft({ output = "basic_materials:oleo_extract"   })
	minetest.clear_craft({ output = "basic_materials:paraffin"      })
	minetest.clear_craft({ output = "basic_materials:plastic_sheet" })
	minetest.register_alias_force("basic_materials:oleo_extract", "oleo:crude_source")

	minetest.override_item("basic_materials:paraffin", {
		description = S("Paraffin Wax")
	})
else
	minetest.register_craftitem("oleo:plastic_sheet", {
		description = S("Plastic Sheeting"),
		inventory_image = "oleo_plastic_sheet.png",
	})

	minetest.register_craftitem("oleo:plastic_strip", {
		description = S("Plastic Strip"),
		inventory_image = "oleo_plastic_strip.png",
	})

	minetest.register_alias("basic_materials:plastic_sheet", "oleo:plastic_sheet")
	minetest.register_alias("basic_materials:plastic_strip", "oleo:plastic_strip")
	minetest.register_alias("basic_materials:oleo_extract",   "oleo:crude_source")
end

minetest.register_craft({
	output = "oleo:plastic_strip 9",
	type   = "shapeless",
	recipe = { "oleo:plastic_sheet 3" },
})

minetest.register_craft({
	output = "oleo:plastic_sheet 9",
	type   = "cooking",
	recipe = "oleo:naphtha_bucket",
})

minetest.register_craft({
	output = "oleo:naphtha_bucket",
	type   = "cooking",
	recipe = "oleo:crude_bucket",
})

minetest.register_craft({
	type = "fuel",
	recipe = "oleo:naphtha_bucket",
	burntime = 30,
})
