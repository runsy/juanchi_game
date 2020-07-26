-- Pillars by Citorva
-- This mode is licensed as MIT licence. This code can't be edited or copyed
-- outside the terms of this license.

local S = minetest.get_translator(minetest.get_current_modname())

local basic_shape = {
	{-0.5, 0.25, -0.5, 0.5, 0.5, 0.5}, -- top
	{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}, -- bot
	{-0.25, -0.25, -0.25, 0.25, 0.25, 0.25}, -- body
}

local bottom_shape = {
	{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}, -- bot
	{-0.25, -0.25, -0.25, 0.25, 0.5, 0.25}, -- body
}

local top_shape = {
	{-0.5, 0.25, -0.5, 0.5, 0.5, 0.5}, -- top
	{-0.25, -0.5, -0.25, 0.25, 0.25, 0.25}, -- body
}

local middle_shape = {
	{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}, -- body
}

local function is_pillar(pos)
	return minetest.get_item_group(minetest.get_node(pos).name, "pillar") > 0
end

local function connected(pos, name, top)
    v_dir = vector.new(0,-1,0)
    
    if top == true then
        v_dir = vector.new(0,1,0)
    end

    local aside = vector.add(pos, v_dir)
	if is_pillar(aside) then
		return true
	end

	return false
end

local function swap(pos, node, name)
	if node.name == name then
		return
	end

	minetest.set_node(pos, {name = name})
end

local function update_pillar(pos)
	if not is_pillar(pos) then
		return
	end
	local node = minetest.get_node(pos)
	local name = node.name
	
	if name:sub(-4) == "_top" or
	   name:sub(-4) == "_bot" or
	   name:sub(-4) == "_mid" then
		name = name:sub(1, -5)
	end

	local any = node.param2
	
	local on_top = connected(pos, name, true)
	local on_bot = connected(pos, name, false)
	
	if on_top and on_bot then
	    swap(pos, node, name .. "_mid", any)
	elseif on_top then
	    swap(pos, node, name .. "_bot", any)
	elseif on_bot then
	    swap(pos, node, name .. "_top", any)
	else
	    swap(pos, node, name, any)
	end
end

minetest.register_on_placenode(function(pos, node)
	if minetest.get_item_group(node, "pillar") then
		update_pillar(pos)
	end
	update_pillar(vector.add(pos, vector.new(0,-1,0)))
	update_pillar(vector.add(pos, vector.new(0,1,0)))
end)

minetest.register_on_dignode(function(pos)
	update_pillar(vector.add(pos, vector.new(0,-1,0)))
	update_pillar(vector.add(pos, vector.new(0,1,0)))
end)

pillars = {}

function pillars.register_pillar(name, def)
    local groups = table.copy(def.groups)
	groups.pillar = 1
	
	local no_inv_groups = table.copy(groups)
	no_inv_groups.not_in_creative_inventory = 1
    
	for k, v in pairs({{"", basic_shape, groups},
	                   {"_top", top_shape, no_inv_groups},
	                   {"_bot", bottom_shape, no_inv_groups},
	                   {"_mid", middle_shape, no_inv_groups}}) do
        local sides = { "top", "bottom" }
	    
        if v[1] == "_top" then
            sides = { "bottom" }
        elseif v[1] == "_bot" then
            sides = { "top" }
        elseif v[1] == "" then
            sides = {}
        end
	
	    minetest.register_node(":pillars:" .. name .. v[1], {
		    description = def.description,
		    drawtype = "nodebox",
		    paramtype = "light",
		    is_ground_content = false,
		    sunlight_propagates = def.sunlight_propagates,
		    inventory_image = def.inventory_image,
		    wield_image = def.wield_image,
		    tiles = def.textures,
		    groups = v[3],
		    drop = "pillars:" .. name,
		    sounds = def.sounds,
		    use_texture_alpha = def.use_texture_alpha or false,
		    node_box = {
			    type = "fixed",
			    fixed = v[2]
		    },
		    selection_box = {
			    type = "fixed",
			    fixed = v[2]
		    },
		    connect_sides = sides
	    })
	end

	minetest.register_craft({
		output = "pillars:" .. name .. " 7",
		recipe = {{def.basenode, def.basenode, def.basenode},
			  {"",def.basenode,""},
			  {def.basenode, def.basenode, def.basenode}}
	})
	minetest.register_craft({
		output = def.basenode .. " 1",
		recipe = {{"pillars:" .. name}}
	})
end

-- Create Pillar from nodes defined in default mod

local default_lib_nodes = {
    -- Define all pillars from stone
    
    {"stone", S("Stone Pillar")},
    {"cobble", S("Cobblestone Pillar")},
    {"stonebrick", S("Stone Brick Pillar"), "stone_brick"},
    {"stone_block", S("Stone Block Pillar")},
    {"mossycobble", S("Mossy Cobblestone Pillar")},
    
    {"desert_stone", S("Desert Stone Pillar")},
    {"desert_cobble", S("Desert Cobblestone Pillar")},
    {"desert_stonebrick", S("Desert Stone Brick Pillar"), "desert_stone_brick"},
    {"desert_stone_block", S("Desert Stone Block Pillar")},
    
    {"sandstone", S("Sandstone Pillar")},
    {"sandstonebrick", S("Sandstone Brick Pillar"), "sandstone_brick"},
    {"sandstone_block", S("Sandstone Block Pillar")},
    
    {"desert_sandstone", S("Desert Sandstone Pillar")},
    {"desert_sandstone_brick", S("Desert Sandstone Brick Pillar")},
    {"desert_sandstone_block", S("Desert Sandstone Block Pillar")},
    
    {"silver_sandstone", S("Silver Sandstone Pillar")},
    {"silver_sandstone_brick", S("Silver Sandstone Brick Pillar")},
    {"silver_sandstone_block", S("Silver Sandstone Block Pillar")},
    
    {"obsidian", S("Obsidian Pillar")},
    {"obsidianbrick", S("Obsidian Brick Pillar"), "obsidian_brick"},
    {"obsidian_block", S("Obsidian Block Pillar")},
    
    -- Define all pillar from wood planks
    {"wood", S("Wood Pillar"), sound = default.node_sound_wood_defaults()},
    {"junglewood", S("Jungle Wood Pillar"), sound = default.node_sound_wood_defaults()},
    {"pine_wood", S("Pine Wood Pillar"), sound = default.node_sound_wood_defaults()},
    {"acacia_wood", S("Acacia Wood Pillar"), sound = default.node_sound_wood_defaults()},
    {"aspen_wood", S("Aspen Wood Pillar"), sound = default.node_sound_wood_defaults()},
}

for k, v in pairs(default_lib_nodes) do
    texture_name = v[1]
    sound = default.node_sound_stone_defaults()
    
    if v[3] then
        texture_name = v[3]
    end
    
    if v.sound then
        sound = v.sound
    end
    
    pillars.register_pillar(v[1], {
	    description = v[2],
	    textures = {"default_" .. texture_name .. ".png"},
	    sounds = sound,
	    groups = {snappy=2, cracky=3, oddly_breakable_by_hand=3},
	    basenode = "default:" .. v[1]
    })
end

