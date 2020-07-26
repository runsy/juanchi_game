-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

local vadd = vector.add
local floor, pi = math.floor, math.pi

local sign_positions = {
	[0] = {{x =  0,    y = 0.18, z = -0.07}, pi},
	[1] = {{x = -0.07, y = 0.18, z =  0},    pi * 0.5},
	[2] = {{x =  0,    y = 0.18, z =  0.07}, 0},
	[3] = {{x =  0.07, y = 0.18, z =  0},    pi * 1.5}
}

local wall_sign_positions = {
	[0] = {{x =  0.43, y = -0.005, z =  0},    pi * 0.5},
	[1] = {{x = -0.43, y = -0.005, z =  0},    pi * 1.5},
	[2] = {{x =  0,    y = -0.005, z =  0.43}, pi},
	[3] = {{x =  0,    y = -0.005, z = -0.43}, 0}
}


local function generate_sign_line_texture(str, row)
	local leftover = floor((20 - #str) * 16 / 2) or 0
	local texture = ""
	local i = 1
	for char in string.gmatch(str, ".[\128-\191]*") do
		local char_byte_1 = char:byte(1)
		local char_byte_2 = char:byte(2)
		if char_byte_2 then
			char_byte_1 = char_byte_2
		end
		if char_byte_1 then
			texture = texture .. ":" .. (i - 1) * 16 + leftover .. ","
				.. row * 20 .. "=signs_" .. char_byte_1 .. ".png"
		end
		i = i + 1
		if i == 20 then
			break
		end
	end
	return texture
end

local function find_any(str, pair, start)
	local ret = 0 -- 0 if not found (indices start at 1)
	for _, needle in pairs(pair) do
		local first = str:find(needle, start)
		if first then
			if ret == 0 or first < ret then
				ret = first
			end
		end
	end
	return ret
end

local disposable_chars = {["\n"] = true, ["\r"] = true, ["\t"] = true, [" "] = true}
local wrap_chars = {"\n", "\r", "\t", " ", "-", "/", ";", ":", ","}
local slugify = dofile(minetest.get_modpath("signs") .. "/slugify.lua")

local function generate_sign_texture(str)
	if not str then
		return "blank.png"
	end
	local row = 0
	local texture = "[combine:" .. 16 * 20 .. "x100"
	local result = {}

	-- Transliterate text
	str = slugify(str)

	while #str > 0 do
		if row > 4 then
			break
		end
		local wrap_i = 0
		local keep_i = 0 -- The last character that was kept
		while wrap_i < #str do
			wrap_i = find_any(str, wrap_chars, wrap_i + 1)
			if wrap_i > 20 then
				if keep_i > 1 then
					wrap_i = keep_i
				else
					wrap_i = 20
				end
				break
			elseif wrap_i == 0 then
				if #str <= 20 then
					wrap_i = #str
				elseif keep_i > 0 then
					wrap_i = keep_i
				else
					wrap_i = #str
				end
				break
			elseif str:sub(wrap_i, wrap_i) == "\n" then
				break
			end
			if not disposable_chars[str:sub(wrap_i, wrap_i)] then
				keep_i = wrap_i
			elseif wrap_i > 1 and not disposable_chars[str:sub(wrap_i - 1, wrap_i - 1)] then
				keep_i = wrap_i - 1
			end
		end
		if wrap_i > 20 then
			wrap_i = 20
		end
		local start_remove = 0
		if disposable_chars[str:sub(1, 1)] then
			start_remove = 1
		end
		local end_remove = 0
		if disposable_chars[str:sub(wrap_i, wrap_i)] then
			end_remove = 1
		end
		local line_string = str:sub(1 + start_remove, wrap_i - end_remove)
		str = str:sub(wrap_i + 1)
		if line_string ~= "" then
			result[row] = line_string
		end
		row = row + 1
	end

	local empty = 0
	if row == 1 then
		empty = 2
	elseif row < 4 then
		empty = 1
	end

	for r, s in pairs(result) do
		texture = texture .. generate_sign_line_texture(s, r + empty)
	end

	return texture
end

minetest.register_entity("signs:sign_text", {
	visual = "upright_sprite",
	textures = {"blank.png", "blank.png"},
	visual_size = {x = 0.7, y = 0.6},
	collisionbox = {0},
	pointable = false,
	on_activate = function(self, staticdata)
		local ent = self.object

		-- remove entity for missing sign
		local node = minetest.get_node_or_nil(ent:get_pos())
		if not node or not (node.name == "signs:sign" or node.name == "signs:wall_sign") then
			ent:remove()
			return
		end

		ent:set_properties({
			textures = {generate_sign_texture(staticdata), "blank.png"}
		})
	end,
	get_staticdata = function(self)
		local meta = minetest.get_meta(self.object:get_pos())
		local text = meta:get_string("sign_text") or ""
		return text
	end
})

local function check_text(pos)
	local meta = minetest.get_meta(pos)
	local text = meta:get_string("sign_text")
	if text and text ~= "" then
		local found = false
		for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.5)) do
			local ent = obj:get_luaentity()
			if ent and ent.name == "signs:sign_text" then
				found = true
				break
			end
		end
		if not found then
			local node = minetest.get_node(pos)
			local p2 = node.param2 or -1
			local sign_pos = sign_positions
			if node.name == "signs:wall_sign" then
				p2 = p2 - 2
				sign_pos = wall_sign_positions
			end
			if p2 > 3 or p2 < 0 then return end
			local obj = minetest.add_entity(vadd(pos,
				sign_pos[p2][1]), "signs:sign_text")
			obj:set_properties({
				textures = {generate_sign_texture(text), "blank.png"}
			})
			obj:set_yaw(sign_pos[p2][2])
		end
	end
end

minetest.register_lbm({
	label = "Check for sign text",
	name = "signs:sign_text",
	nodenames = {"signs:sign", "signs:wall_sign"},
	run_at_every_load = true,
	action = check_text
})

local function construct(pos)
	local meta = minetest.get_meta(pos)
	meta:set_string("formspec", "size[5,3]" ..
			"textarea[1.35,0.5;2.9,1.5;Dtext;" .. S("Enter your text")..":" .. ";${sign_text}]" ..
			"button_exit[1.06,1.65;2.9,1;;" .. S("Save") .. "]")
end

local function destruct(pos)
	for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.5)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "signs:sign_text" then
			obj:remove()
		end
	end
end

local function receive_fields(pos, _, fields, sender, wall)
	if not fields.Dtext then return end
	if minetest.is_protected(pos, sender:get_player_name()) then
		return
	end
	local p2 = minetest.get_node(pos).param2
	local sign_pos = sign_positions
	if wall then
		p2 = p2 - 2
		sign_pos = wall_sign_positions
	end
	if not p2 or p2 > 3 or p2 < 0 then return end
	local sign
	for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.5)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "signs:sign_text" then
			sign = obj
			break
		end
	end
	if not sign then
		sign = minetest.add_entity(vadd(pos,
				sign_pos[p2][1]), "signs:sign_text")
	else
		sign:set_pos(vadd(pos, sign_pos[p2][1]))
	end
	sign:set_properties({
		textures = {generate_sign_texture(fields.Dtext), "blank.png"}
	})
	sign:set_yaw(sign_pos[p2][2])
	local meta = minetest.get_meta(pos)
	meta:set_string("sign_text", fields.Dtext)
	meta:set_string("infotext", fields.Dtext)
end

minetest.register_node("signs:sign", {
	description = S("Sign"),
	tiles = {"signs_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_placement_prediction = "",
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.125, -0.063, 0.375,  0.5,   0.063},
			{-0.063, -0.5,   -0.063, 0.063, -0.125, 0.063}
		}
	},
	groups = {oddly_breakable_by_hand = 1, choppy = 3, attached_node = 1},

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type == "node" then
			local under = pointed_thing.under
			local node = minetest.get_node(under)
			local node_def = minetest.registered_nodes[node.name]
			if node_def and node_def.on_rightclick and
					not (placer and placer:is_player() and
					placer:get_player_control().sneak) then
				return node_def.on_rightclick(under, node, placer, itemstack,
					pointed_thing) or itemstack
			end

			local undery = pointed_thing.under.y
			local posy = pointed_thing.above.y

			local _, result
			if undery < posy then -- Floor sign
				itemstack, result = minetest.item_place(itemstack,
						placer, pointed_thing)
			elseif undery == posy then -- Wall sign
				_, result = minetest.item_place(ItemStack("signs:wall_sign"),
						placer, pointed_thing)
				if result and not (creative and creative.is_enabled_for and
						creative.is_enabled_for(placer)) then
					itemstack:take_item()
				end
			end
			if result then
				minetest.sound_play({name = "default_place_node_hard", gain = 1},
						{pos = pointed_thing.above})
			end
		end

		return itemstack
	end,

	on_construct = construct,
	on_destruct = destruct,
	on_punch = check_text,
	on_receive_fields = receive_fields
})

minetest.register_node("signs:wall_sign", {
	tiles = {"signs_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "wallmounted",
	node_box = {
		type = "wallmounted",
		wall_side = {-0.5, -0.313, -0.438, -0.438, 0.313, 0.438}
	},
	drop = "signs:sign",
	walkable = false,
	groups = {oddly_breakable_by_hand = 1, choppy = 3,
		not_in_creative_inventory = 1, attached_node = 1},

	on_construct = construct,
	on_destruct = destruct,
	on_punch = check_text,

	on_receive_fields = function(pos, _, fields, sender)
		receive_fields(pos, _, fields, sender, true)
	end
})

minetest.register_craft({
	output = "signs:sign 3",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
		{"", "group:stick", ""}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "signs:sign",
	burntime = 10
})
