local modname = "more_armor"
local modpath = minetest.get_modpath(modname)
local S = dofile(modpath .. "/intllib.lua")

-- Register Leather Helmet
minetest.register_tool("more_armor:helmet_leather", {
	description = S("Leather Helmet"),
	inventory_image = "more_armor_inv_helmet_leather.png",
	groups = {armor_head=1, armor_heal=0, armor_use=2000, flammable=1},
    armor_groups = {fleshy=5},
    damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
})

-- Register Leather Chestplates
minetest.register_tool("more_armor:chestplate_leather", {
	description = S("Leather Chestplate"),
	inventory_image = "more_armor_inv_chestplate_leather.png",
	groups = {armor_torso=1, armor_heal=0, armor_use=2000, flammable=1},
    armor_groups = {fleshy=10},
    damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
})

minetest.register_tool("more_armor:chestplate_leather_padded", {
	description = S("Padded Leather Chestplate"),
	inventory_image = "more_armor_inv_chestplate_leather_padded.png",
	groups = {armor_torso=1, armor_heal=0, armor_use=2000, flammable=1},
    armor_groups = {fleshy=10},
    damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
})

minetest.register_tool("more_armor:chestplate_leather_chain", {
	description = "Chainmail & Leather Chestplate",
	inventory_image = "more_armor_inv_chestplate_leather_chain.png",
	groups = {armor_torso=1, armor_heal=0, armor_use=2000, flammable=1},
    armor_groups = {fleshy=10},
    damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
})

-- Register Leather Leggings
minetest.register_tool("more_armor:leggings_leather", {
	description = S("Leather Leggings"),
	inventory_image = "more_armor_inv_leggings_leather.png",
	groups = {armor_legs=1, armor_heal=0, armor_use=2000, flammable=1},
    armor_groups = {fleshy=10},
    damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
})

minetest.register_tool("more_armor:leggings_leather_padded", {
	description = S("Padded Leather Leggings"),
	inventory_image = "more_armor_inv_leggings_leather_padded.png",
	groups = {armor_legs=1, armor_heal=0, armor_use=2000, flammable=1},
    armor_groups = {fleshy=10},
    damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
})

minetest.register_tool("more_armor:leggings_leather_chain", {
	description = S("Chainmail & Leather Leggings"),
	inventory_image = "more_armor_inv_leggings_leather_chain.png",
	groups = {armor_legs=1, armor_heal=0, armor_use=2000, flammable=1},
    armor_groups = {fleshy=10},
    damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
})

-- Register Leather Boots
minetest.register_tool("more_armor:boots_leather", {
    description = S("Leather Boots"),
    inventory_image = "more_armor_inv_boots_leather.png",
    groups = {armor_feet=1, armor_heal=0, armor_use=2000, flammable=1},
    armor_groups = {fleshy=5},
    damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},    
	})

-- Register crafting recipes
minetest.register_craft({
    output = "more_armor:helmet_leather",
    recipe = {
        {"mobs:leather", "mobs:leather", "mobs:leather"},
        {"mobs:leather", "", "mobs:leather"},
        {"", "", ""},
    },
})

minetest.register_craft({
    output = "more_armor:chestplate_leather",
    recipe = {
        {"mobs:leather", "", "mobs:leather"},
        {"mobs:leather", "mobs:leather", "mobs:leather"},
        {"mobs:leather", "mobs:leather", "mobs:leather"},
    },
})

minetest.register_craft({
    output = "more_armor:chestplate_leather_padded",
    recipe = {
        {"mobs:leather", "", "mobs:leather"},
        {"mobs:leather", "group:wool", "mobs:leather"},
        {"mobs:leather", "group:wool", "mobs:leather"},
    },
})

minetest.register_craft({
    output = "more_armor:chestplate_leather_chain",
    recipe = {
        {"mobs:leather", "", "mobs:leather"},
        {"mobs:leather", "default:steel_ingot", "mobs:leather"},
        {"mobs:leather", "default:steel_ingot", "mobs:leather"},
    },
})

minetest.register_craft({
    output = "more_armor:leggings_leather",
    recipe = {
        {"mobs:leather", "mobs:leather", "mobs:leather"},
        {"mobs:leather", "", "mobs:leather"},
        {"mobs:leather", "", "mobs:leather"},
    },
})

minetest.register_craft({
    output = "more_armor:leggings_leather_padded",
    recipe = {
        {"group:wool", "mobs:leather", "group:wool"},
        {"mobs:leather", "", "mobs:leather"},
        {"mobs:leather", "", "mobs:leather"},
    },
})

minetest.register_craft({
    output = "more_armor:leggings_leather_chain",
    recipe = {
        {"default:steel_ingot", "mobs:leather", "default:steel_ingot"},
        {"mobs:leather", "", "mobs:leather"},
        {"mobs:leather", "", "mobs:leather"},
    },
})

minetest.register_craft({
    output = "more_armor:boots_leather",
    recipe = {
        {"mobs:leather", "", "mobs:leather"},
        {"mobs:leather", "", "mobs:leather"},
    },
})
