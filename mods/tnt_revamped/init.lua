if not tnt then
	tnt = {}
end

-- Default to enabled when in singleplayer
local enable_tnt = minetest.settings:get_bool("enable_tnt")
if enable_tnt == nil then
	enable_tnt = minetest.is_singleplayer()
end

-- loss probabilities array (one in X will be lost)
tnt.loss_prob = {}

tnt.loss_prob["default:cobble"] = 3
tnt.loss_prob["default:dirt"] = 4

local tnt_radius = tonumber(minetest.settings:get("tnt_radius") or 3)
local tnt_entity_velocity_mul = tonumber(minetest.settings:get("tnt_revamped.tnt_entity_velocity_mul") or 2)
local player_velocity_mul = tonumber(minetest.settings:get("tnt_revamped.player_velocity_mul") or 10)
local entity_velocity_mul = tonumber(minetest.settings:get("tnt_revamped.entity_velocity_mul") or 10)
local tnt_damage_nodes = minetest.settings:get_bool("tnt_revamped.damage_nodes") or false
local tnt_damage_entities = minetest.settings:get_bool("tnt_revamped.damage_entities") or false
local tnt_explosion = minetest.settings:get("tnt_revamped.explosion") or "default"

local water_nodes = {}

minetest.register_on_mods_loaded(function() 
	for name, def in pairs(minetest.registered_nodes) do
		if def.liquidtype ~= "none" then
			water_nodes[name] = true
		end
	end
end)

-- Fill a list with data for content IDs, after all nodes are registered
local cid_data = {}
minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_nodes) do
		cid_data[minetest.get_content_id(name)] = {
			name = name,
			drops = def.drops,
			flammable = def.groups.flammable,
			on_blast = def.on_blast,
		}
	end
end)

local function rand_pos(center, pos, radius)
	local def
	local reg_nodes = minetest.registered_nodes
	local i = 0
	repeat
		-- Give up and use the center if this takes too long
		if i > 4 then
			pos.x, pos.z = center.x, center.z
			break
		end
		pos.x = center.x + math.random(-radius, radius)
		pos.z = center.z + math.random(-radius, radius)
		def = reg_nodes[minetest.get_node(pos).name]
		i = i + 1
	until def and not def.walkable
end

-- Just another eject_drops function may get rid of it in the future.
local function eject_drops2(drops, pos)
	local drop_pos = vector.new(pos)
	for _, item in pairs(drops) do
		local count = item.count or 1
		local dropitem = ItemStack(item.name)
		dropitem:set_count(count)
		local obj = minetest.add_item(drop_pos, dropitem)
		if obj then
			obj:get_luaentity().collect = true
			obj:set_acceleration({x = 0, y = -10, z = 0})
			obj:set_velocity({x = math.random(-3, 3),
					y = math.random(0, 10),
					z = math.random(-3, 3)})
		end
	end
end

local function eject_drops(drops, pos, radius)
	local drop_pos = vector.new(pos)
	for _, item in pairs(drops) do
		local count = math.min(item:get_count(), item:get_stack_max())
		while count > 0 do
			local take = math.max(1,math.min(radius * radius,
					count,
					item:get_stack_max()))
			rand_pos(pos, drop_pos, radius)
			local dropitem = ItemStack(item)
			dropitem:set_count(take)
			local obj = minetest.add_item(drop_pos, dropitem)
			if obj then
				obj:get_luaentity().collect = true
				obj:set_acceleration({x = 0, y = -10, z = 0})
				obj:set_velocity({x = math.random(-3, 3),
						y = math.random(0, 10),
						z = math.random(-3, 3)})
			end
			count = count - take
		end
	end
end

local function add_drop(drops, item)
	item = ItemStack(item)
	local name = item:get_name()
	if tnt.loss_prob[name] ~= nil and math.random(1, tnt.loss_prob[name]) == 1 then
		return
	end

	local drop = drops[name]
	if drop == nil then
		drops[name] = item
	else
		drop:set_count(drop:get_count() + item:get_count())
	end
end

local basic_flame_on_construct -- cached value
local function destroy(drops, npos, cid, c_air, c_fire,
		on_blast_queue, on_construct_queue,
		ignore_protection, ignore_on_blast, owner)

	local def = cid_data[cid]

	if not def then
		return c_air
	elseif not ignore_on_blast and def.on_blast then
		on_blast_queue[#on_blast_queue + 1] = {
			pos = vector.new(npos),
			on_blast = def.on_blast
		}
		return cid
	elseif def.flammable and basic_flame_on_construct then
		on_construct_queue[#on_construct_queue + 1] = {
			fn = basic_flame_on_construct,
			pos = vector.new(npos)
		}
		return c_fire
	else
		local node_drops = minetest.get_node_drops(def.name, "")
		for _, item in pairs(node_drops) do
			add_drop(drops, item)
		end
		return c_air
	end
end

local function calc_velocity(pos1, pos2, old_vel, power)
	-- Avoid errors caused by a vector of zero length
	if vector.equals(pos1, pos2) then
		return old_vel
	end

	local vel = vector.direction(pos1, pos2)
	vel = vector.normalize(vel)
	vel = vector.multiply(vel, power)

	-- Divide by distance
	local dist = vector.distance(pos1, pos2)
	dist = math.max(dist, 1)
	vel = vector.divide(vel, dist)

	-- Limit to terminal velocity
	dist = vector.length(vel)
	if dist > 250 then
		vel = vector.divide(vel, dist / 250)
	end
	return vel
end

local function entity_physics(pos, radius, drops, in_water)
	local objs = minetest.get_objects_inside_radius(pos, radius)
	for _, obj in pairs(objs) do
		local obj_pos = obj:get_pos()
		local dist = math.max(1, vector.distance(pos, obj_pos))

		local damage = (4 / dist) * radius
		if obj:is_player() then
			local obj_vel = obj:get_player_velocity()
			obj:add_player_velocity(calc_velocity(pos, obj_pos,
					obj_vel, radius * player_velocity_mul))

			if not in_water or (in_water and tnt_damage_entities) then
				local hp = obj:get_hp() - damage
				if hp < 0 then
					hp = 0
				end
				obj:set_hp(hp)
			end
		elseif obj:get_entity_name() ~= "tnt_revamped:empty_tnt_entity" then
			local do_damage = true
			local do_knockback = true
			local entity_drops = {}
			local luaobj = obj:get_luaentity()
			local objdef = minetest.registered_entities[luaobj.name]

			if objdef and objdef.on_blast then
				do_damage, do_knockback, entity_drops = objdef.on_blast(luaobj, damage)
			end

			if do_knockback then
				local obj_vel = obj:get_velocity()
				obj:add_velocity(calc_velocity(pos, obj_pos,
						obj_vel, radius * entity_velocity_mul))
			end
			if do_damage and (not in_water or (in_water and tnt_damage_entities)) then
				if not obj:get_armor_groups().immortal then
					obj:punch(obj, 1.0, {
						full_punch_interval = 1.0,
						damage_groups = {fleshy = damage},
					}, nil)
				end
			end
			for _, item in pairs(entity_drops) do
				add_drop(drops, item)
			end
		else
			obj:get_luaentity().timer = 0
			local obj_vel = obj:get_velocity()
			obj:add_velocity(calc_velocity(pos, obj_pos, obj_vel, radius * tnt_entity_velocity_mul))
		end
	end
end

local function add_effects(pos, radius, drops)
	minetest.add_particle({
		pos = pos,
		velocity = vector.new(),
		acceleration = vector.new(),
		expirationtime = 0.4,
		size = radius * 10,
		collisiondetection = false,
		vertical = false,
		texture = "tnt_boom.png",
		glow = 15,
	})
	minetest.add_particlespawner({
		amount = 64,
		time = 0.5,
		minpos = vector.subtract(pos, radius / 2),
		maxpos = vector.add(pos, radius / 2),
		minvel = {x = -10, y = -10, z = -10},
		maxvel = {x = 10, y = 10, z = 10},
		minacc = vector.new(),
		maxacc = vector.new(),
		minexptime = 1,
		maxexptime = 2.5,
		minsize = radius * 3,
		maxsize = radius * 5,
		texture = "tnt_smoke.png",
	})

	-- we just dropped some items. Look at the items entities and pick
	-- one of them to use as texture
	local texture = "tnt_blast.png" --fallback texture
	local most = 0
	for name, stack in pairs(drops) do
		local count = stack:get_count()
		if count > most then
			most = count
			local def = minetest.registered_nodes[name]
			if def and def.tiles and def.tiles[1] then
				texture = def.tiles[1]
			end
		end
	end

	minetest.add_particlespawner({
		amount = 64,
		time = 0.1,
		minpos = vector.subtract(pos, radius / 2),
		maxpos = vector.add(pos, radius / 2),
		minvel = {x = -3, y = 0, z = -3},
		maxvel = {x = 3, y = 5,  z = 3},
		minacc = {x = 0, y = -10, z = 0},
		maxacc = {x = 0, y = -10, z = 0},
		minexptime = 0.8,
		maxexptime = 2.0,
		minsize = radius * 0.66,
		maxsize = radius * 2,
		texture = texture,
		collisiondetection = true,
	})
end

local function tnt_explode(pos, radius, ignore_protection, ignore_on_blast, owner, explode_center, in_water)
	
	if in_water == nil then
		in_water = false
	end

	-- recalculate new radius
	radius = math.floor(radius * math.pow(1, 1/3))

	if not in_water or tnt_damage_nodes then
	
		pos = vector.round(pos)
		local p1 = vector.subtract(pos, 2)
		local p2 = vector.add(pos, 2)
		local count = 0
		local c_air = minetest.get_content_id("air")
		
		count = 1

		-- perform the explosion
		local vm = VoxelManip()
		local pr = PseudoRandom(os.time())
		p1 = vector.subtract(pos, radius)
		p2 = vector.add(pos, radius)
		local minp, maxp = vm:read_from_map(p1, p2)
		local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
		local data = vm:get_data()

		local drops = {}
		local on_blast_queue = {}
		local on_construct_queue = {}
		local c_fire

		if minetest.registered_nodes["fire:basic_flame"] then
			basic_flame_on_construct = minetest.registered_nodes["fire:basic_flame"].on_construct
			c_fire = minetest.get_content_id("fire:basic_flame")
		end
		for z = -radius, radius do
			for y = -radius, radius do
			local vi = a:index(pos.x + (-radius), pos.y + y, pos.z + z)
				for x = -radius, radius do
					local r = vector.length(vector.new(x, y, z))
					if (radius * radius) / (r * r) >= (pr:next(80, 125) / 100) then
						local cid = data[vi]
						local p = {x = pos.x + x, y = pos.y + y, z = pos.z + z}
						if cid ~= c_air then
							data[vi] = destroy(drops, p, cid, c_air, c_fire,
								on_blast_queue, on_construct_queue,
								ignore_protection, ignore_on_blast, owner)
						end
					end
					vi = vi + 1
				end
			end
		end
	
		vm:set_data(data)
		vm:write_to_map()
		vm:update_map()
		vm:update_liquids()

		-- call check_single_for_falling for everything within 1.5x blast radius
		for y = -radius * 1.5, radius * 1.5 do
			for z = -radius * 1.5, radius * 1.5 do
				for x = -radius * 1.5, radius * 1.5 do
					local rad = {x = x, y = y, z = z}
					local s = vector.add(pos, rad)
					local r = vector.length(rad)
					if r / radius < 1.4 then
						minetest.check_single_for_falling(s)
					end
				end
			end
		end

		for _, queued_data in pairs(on_blast_queue) do
			local dist = math.max(1, vector.distance(queued_data.pos, pos))
			local intensity = (radius * radius) / (dist * dist)
			local node_drops = queued_data.on_blast(queued_data.pos, intensity, pos)
			if node_drops then
				for _, item in pairs(node_drops) do
					add_drop(drops, item)
				end
			end
		end

		for _, queued_data in pairs(on_construct_queue) do
			queued_data.fn(queued_data.pos)
		end

		minetest.log("action", "TNT owned by " .. owner .. " detonated at " ..
			minetest.pos_to_string(pos) .. " with radius " .. radius)

		return drops, radius
	end

	minetest.log("action", "TNT owned by " .. owner .. " detonated at " ..
		minetest.pos_to_string(pos) .. " with radius " .. radius)

	return {}, radius
end

function tnt.boom(pos, def, owner, in_water)
	local def1 = def or {}
	def1.radius = def.radius or 1
	def1.damage_radius = def.damage_radius or def.radius * 2
	if not owner then
		owner = "<Unknown>"
	end
	if def.boom_sound then
		if not def.boom_sound.def then
			def.boom_sound.def = {}
		end
		def.boom_sound.def.pos = pos
		minetest.sound_play(def.boom_sound.name, def.boom_sound.def)
	end
	local drops, radius = tnt_explode(pos, def1.radius, def1.ignore_protection,
			def1.ignore_on_blast, owner, def1.explode_center, in_water)
	-- append entity drops
	local damage_radius = (radius / math.max(1, def1.radius)) * def1.damage_radius
	entity_physics(pos, damage_radius, drops, in_water)
	if not def1.disable_drops then
		eject_drops(drops, pos, radius)
	end
	add_effects(pos, radius, drops)
	minetest.log("action", "A TNT explosion occurred at " .. minetest.pos_to_string(pos) ..
		" with radius " .. radius)
end

function tnt.create_entity(pos, owner, jump, def)
	local obj = minetest.add_entity(pos, "tnt_revamped:empty_tnt_entity")
	local ent = obj:get_luaentity()
	ent.def = def

	local old_meta = minetest.get_meta(pos)
	
	if not owner then
		owner = old_meta:get_string("owner")
	end
	ent.owner = owner

	obj:set_acceleration({x = 0, y = -10, z = 0})

	if jump then
		obj:set_velocity({x = 0, y = jump, z = 0})
	end
	
	local oldnode = old_meta:get_string("oldnode")
	local old_param2 = old_meta:get_string("old_param2")

	if oldnode ~= "" and old_param2 ~= "" then
		minetest.set_node(pos, {name = oldnode, param2 = tonumber(old_param2)})
		ent.flow = true
	elseif oldnode ~= "" then
		minetest.set_node(pos, {name = oldnode})
	else
		minetest.remove_node(pos)
	end

	return obj
end

local function node_ok(pos)

	local node = minetest.get_node_or_nil(pos)

	if node and minetest.registered_nodes[node.name] then
		return node
	end

	return minetest.registered_nodes["default:dirt"]
end

-- water flow functions by QwertyMine3, edited by TenPlus1
-- Copied from https://notabug.org/TenPlus1/builtin_item
local function to_unit_vector(dir_vector)

	local inv_roots = {
		[0] = 1,
		[1] = 1,
		[2] = 0.70710678118655,
		[4] = 0.5,
		[5] = 0.44721359549996,
		[8] = 0.35355339059327
	}

	local sum = dir_vector.x * dir_vector.x + dir_vector.z * dir_vector.z

	return {
		x = dir_vector.x * inv_roots[sum],
		y = dir_vector.y,
		z = dir_vector.z * inv_roots[sum]
	}
end

local function quick_flow_logic(node, pos_testing, direction)

	local node_testing = node_ok(pos_testing)

	if minetest.registered_nodes[node_testing.name].liquidtype ~= "flowing"
	and minetest.registered_nodes[node_testing.name].liquidtype ~= "source" then
		return 0
	end

	local param2_testing = node_testing.param2

	if param2_testing < node.param2 then

		if (node.param2 - param2_testing) > 6 then
			return -direction
		else
			return direction
		end

	elseif param2_testing > node.param2 then

		if (param2_testing - node.param2) > 6 then
			return direction
		else
			return -direction
		end
	end

	return 0
end

local function quick_flow(pos, node)

	if minetest.registered_nodes[node.name].liquidtype == "none" then
		return {x = 0, y = 0, z = 0}
	end

	local x, z = 0, 0

	x = x + quick_flow_logic(node, {x = pos.x - 1, y = pos.y, z = pos.z},-1)
	x = x + quick_flow_logic(node, {x = pos.x + 1, y = pos.y, z = pos.z}, 1)
	z = z + quick_flow_logic(node, {x = pos.x, y = pos.y, z = pos.z - 1},-1)
	z = z + quick_flow_logic(node, {x = pos.x, y = pos.y, z = pos.z + 1}, 1)

	return to_unit_vector({x = x, y = 0, z = z})
end

function tnt.register_tnt(def)
	local name
	if not def.name:find(':') then
		name = "tnt:" .. def.name
	else
		name = def.name
		def.name = def.name:match(":([%w_]+)")
	end
	if not def.tiles then def.tiles = {} end
	local tnt_top = def.tiles.top or def.name .. "_top.png"
	local tnt_bottom = def.tiles.bottom or def.name .. "_bottom.png"
	local tnt_side = def.tiles.side or def.name .. "_side.png"
	local tnt_burning = def.tiles.burning or def.name .. "_top_burning.png"
	if not def.damage_radius then def.damage_radius = def.radius * 2 end
	if not def.time then def.time = 4 end
	if not def.jump then def.jump = 3 end
	
	if enable_tnt then
		local function ignite_sound_func(pos)
			if def.ignite_sound then
				if not def.ignite_sound.def then
					def.ignite_sound.def = {}
				end
				def.ignite_sound.def.pos = pos
				minetest.sound_play(def.ignite_sound.name, def.ignite_sound.def)
			end
		end
		local tiles = {tnt_burning,
				tnt_bottom, tnt_side, tnt_side, tnt_side, tnt_side
		}

		local function convert_to_entity(pos, def, tiles)
			local meta = minetest.get_meta(pos)
			local name = meta:get_string("owner") or nil
			ignite_sound_func(pos)
			local obj = tnt.create_entity(pos, name, def.jump, def)
			obj:set_properties({textures = tiles, visual = "cube", visual_size = {x = 1, y = 1, z = 1}})
			local ent = obj:get_luaentity()
			if ent then
				ent.time = def.time
			end
		end
		
		local node_def = {
			description = def.description,
			tiles = {tnt_top, tnt_bottom, tnt_side},
			is_ground_content = false,
			groups = {dig_immediate = 2, mesecon = 2, tnt = 1, flammable = 5, explosive = def.radius, blast_resistance = 25, strength = def.strength},
			after_place_node = function(pos, placer)
				if placer:is_player() then
					local meta = minetest.get_meta(pos)
					meta:set_string("owner", placer:get_player_name())
				end
			end,
			on_punch = function(pos, node, puncher)
				local item_name = puncher:get_wielded_item():get_name()
				local player_name = puncher:get_player_name()
				if minetest.registered_items[item_name].groups.torch then
					if minetest.is_protected(pos, player_name) then
						minetest.chat_send_player(player_name, "This area is protected")
						return
					end
					convert_to_entity(pos, def, tiles)
				end
			end,
			on_blast = function(pos, intensity, blaster)
				convert_to_entity(pos, def, tiles)
			end,
			on_blast_break = function(pos)
				convert_to_entity(pos, def, tiles)
			end,
			mesecons = {effector =
				{action_on =
					function(pos)
						convert_to_entity(pos, def, tiles)
					end
				}
			},
			on_burn = function(pos)
				convert_to_entity(pos, def, tiles)
			end,
			on_ignite = function(pos, igniter)
				convert_to_entity(pos, def, tiles)
			end,
		}
		if not minetest.registered_nodes[name] then
			minetest.register_node(":" .. name, node_def)
		else
			minetest.override_item(name, node_def)
		end
	end
end

minetest.register_entity("tnt_revamped:empty_tnt_entity", {
	name = "empty_tnt_entity",
	timer = 0,
	time = 0,
	def = {},
	drops = {},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	physical = true,
	collide_with_objects = false,
	static_save = false,
	owner = "",
	on_step = function(self, dtime)
		self.time = self.time - dtime
		local pos = self.object:get_pos()
		local v = self.object:get_velocity()
		local flow = self.flow

		-- water flowing
		if flow then
			local node = minetest.get_node_or_nil(pos)
			local def_ = node and minetest.registered_nodes[node.name]
			
			if def_ and def_.liquidtype == "flowing" then
				local vec = quick_flow(pos, node)
				self.object:set_velocity({x = vec.x, y = v.y, z = vec.z})
			else
				self.timer = self.timer + dtime
			end
		else
			self.timer = self.timer + dtime
		end

		if self.timer >= 0.2 then
			local node = minetest.env:get_node({x = pos.x, y = pos.y - 0.667, z = pos.z})
			local node_name = node.name
			local r_node = minetest.registered_nodes[node_name]
			if r_node.walkable then
				self.object:set_velocity({x = 0, y = 0, z = 0})
			elseif not flow and r_node.liquidtype then
				self.flow = true
			end

			self.timer = 0
		end
		
		if self.time <= 0 then
			if water_nodes[minetest.get_node(pos).name] then
				tnt.boom(pos, self.def, self.owner, true)
			else
				tnt.boom(pos, self.def, self.owner, false)
			end
			if self.drops then
				eject_drops2(self.drops, pos, self.def.radius)
			end
			self.object:remove()
		end
	end,
	on_blast = function(pos, intensity, blaster)
		return
	end,
	get_staticdata = function(self)
		return minetest.serialize({timer = self.timer, time = self.time, flow = self.flow, owner = self.owner, def = self.def, drops = self.drops})
	end,
	on_activate = function(self, staticdata)
		self.object:set_armor_groups({immortal = 1})
		local ds = core.deserialize(staticdata)
		if ds then
			self.timer = ds.timer
			self.time = ds.time
			self.owner = ds.owner
			self.flow = ds.flow
			self.def = ds.def
			self.drops = ds.drops
		end
	end,
})

if minetest.registered_nodes["tnt:tnt"] then
	tnt.register_tnt({
		name = "tnt:tnt",
		description = "TNT",
		radius = tnt_radius,
		strength = 1000,
		time = 4,
		jump = 3,
		ignite_sound = {name = "tnt_ignite"},
		boom_sound = {name = "tnt_explode", def = {gain = 2.5, max_hear_distance = 128}}
	})
end
if tnt_explosion == "explosions" then
	local old_boom = tnt.boom
	tnt.boom = function(pos, def, owner, in_water)
		if not in_water or tnt_damage_nodes then
			explosions.explode(pos, def)
		else
			old_boom(pos, def, owner, in_water)
		end
	end
end
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	local groups = minetest.registered_nodes[newnode.name].groups
	if groups.tnt or groups.volatile then
		local meta = minetest.get_meta(pos)
		local name = oldnode.name
		local def = minetest.registered_items[name]
		if def.liquidtype == "flowing" then
			meta:set_string("oldnode", name)
			meta:set_string("old_param2", oldnode.param2)
		else
			meta:set_string("oldnode", name)
		end
	end
end)
