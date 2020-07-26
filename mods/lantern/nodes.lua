local S = minetest.get_translator(minetest.get_current_modname())

--
-- register nodes:
--

minetest.register_node("lantern:lantern", {
	description = S("Lantern"),
	drawtype = "nodebox",
	tiles = {"lantern_tb.png","lantern_tb.png","lantern.png"},
	inventory_image = minetest.inventorycube("lantern_inv.png"),
	wield_image = minetest.inventorycube("lantern_inv.png"),
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	light_source = LIGHT_MAX - 1,
	walkable = false,
	groups = {cracky = 2, dig_immediate = 3},
	sounds = default.node_sound_glass_defaults(),
	node_box = {
		type = "wallmounted",
		wall_top = {-1/6, 1/6, -1/6, 1/6, 0.5, 1/6},
		wall_bottom = {-1/6, -0.5, -1/6, 1/6, -1/6, 1/6},
		wall_side = {-1/6, -1/6, -1/6, -0.5, 1/6, 1/6},
	},
})

minetest.register_node("lantern:fence_black", {
	description = S("Black Fence"),
	drawtype = "fencelike",
	tiles = {"default_obsidian.png"},
	paramtype = "light",
	is_ground_content = true,
	walkable = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
})

minetest.register_node("lantern:candle", {
	description = S("Candle"),
	drawtype = "plantlike",
	inventory_image = "candle_inv.png",
	tiles = {
		{name="candle.png", animation={type = "vertical_frames", aspect_w = 32, aspect_h = 32, length = 0.8}},
	},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	light_source = LIGHT_MAX - 1,
	groups = {dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.15, -0.5, -0.15, 0.15, 0.2, 0.15 },
	},
})

minetest.register_node("lantern:lamp", {
	description = S("Lamp"),
	tiles = {"default_obsidian.png", "default_obsidian.png", "lantern_lamp.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = true,
	light_source = LIGHT_MAX - 1,
	groups = {cracky = 2, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
})


-- this node is only used  for lampost and can't be crafted/used by the player
minetest.register_node("lantern:fence_lampost", {
	description = S("Fence Lamppost"),
	drawtype = "fencelike",
	tiles = {"default_obsidian.png"},
	paramtype = "light",
	drop = "",
	pointable = false,
	groups = {choppy = 2, not_in_creative_inventory = 1},
	sounds = default.node_sound_defaults(),
})

-- tests if a player could place there
local function node_allowed(pos, pname)
	if minetest.is_protected(pos, pname) then
		return false
	end
	local def = minetest.registered_nodes[minetest.get_node(pos).name]
	if not def
	or not def.buildable_to then
		return false
	end
	return true
end

-- how x and z change for different param2s
local lamp_adps = {[0]={0,-1}, {-1,0}, {0,1}, {1,0}}

-- places the lamp and its fence lampost
local function place_lamp(pos, param2, pname)
	local ax,az = unpack(lamp_adps[param2])
	minetest.remove_node(pos)
	pos.y = pos.y-1
	for _ = 0,3 do
		pos.y = pos.y+1
		if node_allowed(pos, pname) then
			minetest.set_node(pos, {name = "lantern:fence_lampost"})
		end
	end

	if az == 0 then
		pos.x = pos.x+ax
	else
		pos.z = pos.z+az
	end
	if node_allowed(pos, pname) then
		minetest.set_node(pos, {name = "lantern:fence_lampost"})
	end

	pos.y = pos.y-1
	if node_allowed(pos, pname) then
		minetest.set_node(pos, {name = "lantern:lamp_post", param2 = param2})
	end
end

-- removes the lampost
local function remove_lamp(pos, param2)
	local ax,az = unpack(lamp_adps[param2])
	if az == 0 then
		pos.x = pos.x-ax
	else
		pos.z = pos.z-az
	end
	pos.y = pos.y-2

	pos.y = pos.y-1
	for _ = 0,3 do
		pos.y = pos.y+1
		if minetest.get_node(pos).name == "lantern:fence_lampost" then
			minetest.remove_node(pos)
		end
	end

	if az == 0 then
		pos.x = pos.x+ax
	else
		pos.z = pos.z+az
	end
	if minetest.get_node(pos).name == "lantern:fence_lampost" then
		minetest.remove_node(pos)
	end
end

minetest.register_node("lantern:lamp_post", {
	description = S("Lamp post"),
	tiles = {"default_obsidian.png", "default_obsidian.png", "lantern_lamp.png"},
	inventory_image = "lamppost_inv.png",
	wield_image = "lamppost_inv.png",
	paramtype = "light",
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	sunlight_propagates = true,
	light_source = LIGHT_MAX - 1,
	groups = {cracky = 2, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -2.5, 0.8, 0.2, -1.3, 1.2}
	},
	on_destruct = function(pos)
		remove_lamp(pos, minetest.get_node(pos).param2)
	end,
	after_place_node = function(pos, player)
		place_lamp(pos, minetest.get_node(pos).param2, player:get_player_name())
	end,
})


--
-- legacy
--

for i = 1,4 do
	minetest.register_alias("lantern:lantern_lampost"..i, "lantern:lamp_post")
	minetest.register_node("lantern:lamp"..i, {groups = {old_lamp = 1, not_in_creative_inventory = 1}})
end

-- gets param2 from the old typ
local typ2param = {1,0,3,2}

minetest.register_abm({
	nodenames = {"group:old_lamp"},
	interval = 10,
	chance = 1,
	action = function(pos, node)
		local typ = tonumber(string.sub(node.name, -1))
		if not typ then
			error("[lantern] legacy: error with replacing old lamp")
		end
		minetest.set_node(pos, {name = "lantern:lamp_post", param2 = typ2param[typ]})
	end,
})
