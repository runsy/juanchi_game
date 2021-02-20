local modpath = ...
local climatez = {}
climatez.wind = {}
climatez.climates = {}
climatez.players = {}
climatez.settings = {}

--Settings

local settings = Settings(modpath .. "/climatez.conf")

climatez.settings.climate_min_height = tonumber(settings:get("climate_min_height"))
climatez.settings.climate_change_ratio = tonumber(settings:get("climate_change_ratio"))
climatez.settings.radius = tonumber(settings:get("climate_radius"))
climatez.settings.climate_duration = tonumber(settings:get("climate_duration"))
climatez.settings.duration_random_ratio = tonumber(settings:get("climate_duration_random_ratio"))
climatez.settings.climate_period = tonumber(settings:get("climate_period"))
climatez.settings.climate_rain_sound = settings:get_bool("climate_rain_sound")
climatez.settings.thunder_sound = settings:get_bool("thunder_sound")
climatez.settings.storm_chance = tonumber(settings:get("storm_chance"))
climatez.settings.lightning = settings:get_bool("lightning")
climatez.settings.lightning_chance = tonumber(settings:get("lightning_chance"))

local climate_max_height = tonumber(minetest.settings:get('cloud_height', true)) or 120
local check_light = minetest.is_yes(minetest.settings:get_bool('light_roofcheck', true))

--Helper Functions

function remove_table_by_key(tab, key)
	local i = 0
	local keys, values = {},{}
	for k, v in pairs(tab) do
		i = i + 1
		keys[i] = k
		values[i] = v
	end

	while i > 0 do
		if keys[i] == key then
			table.remove(keys, i)
			table.remove(values, i)
			break
		end
		i = i - 1
	end

	local new_tab = {}

	for i = 1, #keys do
		new_tab[keys[i]] = values[i]
	end

	return new_tab
end

local function player_inside_climate(player_pos)
	--This function returns the climate_id if inside and true/false if the climate is enabled dor not
	--check altitude
	if (player_pos.y < climatez.settings.climate_min_height) or (player_pos.y > climate_max_height) then
		return false, nil
	end
	--check if on water
	local node_name = minetest.get_node(player_pos).name
	if minetest.registered_nodes[node_name] and (
		minetest.registered_nodes[node_name]["liquidtype"] == "source" or
		minetest.registered_nodes[node_name]["liquidtype"] == "flowing") then
			return false, false
	end
	--If sphere's centre coordinates is (cx,cy,cz) and its radius is r,
	--then point (x,y,z) is in the sphere if (x−cx)2+(y−cy)2+(z−cz)2<r2.
	for i, climate in ipairs(climatez.climates) do
		local climate_center = climatez.climates[i].center
		if climatez.settings.radius > math.sqrt((player_pos.x - climate_center.x)^2+
			(player_pos.y - climate_center.y)^2 +
			(player_pos.z - climate_center.z)^2
			) then
				if climatez.climates[i].disabled then
					return i, true
				else
					return i, false
				end
		end
	end
	return false, false
end

local function has_light(minp, maxp)
	local manip = minetest.get_voxel_manip()
	local e1, e2 = manip:read_from_map(minp, maxp)
	local area = VoxelArea:new{MinEdge=e1, MaxEdge=e2}
	local data = manip:get_light_data()
	local node_num = 0
	local light = false

	for i in area:iterp(minp, maxp) do
		node_num = node_num + 1
		if node_num < 5 then
			if data[i] and data[i] == 15 then
				light = true
				break
			end
		else
			node_num = 0
		end
	end

	return light
end

--DOWNFALLS REGISTRATIONS

climatez.registered_downfalls = {}

local function register_downfall(name, def)
	local new_def = table.copy(def)
	climatez.registered_downfalls[name] = new_def
end

register_downfall("rain", {
	min_pos = {x = -15, y = 10, z = -15},
	max_pos = {x = 15, y = 10, z = 15},
	falling_speed = 10,
	amount = 20,
	exptime = 1,
	size = 1,
	texture = "climatez_rain.png",
})

register_downfall("storm", {
	min_pos = {x = -15, y = 20, z = -15},
	max_pos = {x = 15, y = 20, z = 15},
	falling_speed = 20,
	amount = 30,
	exptime = 1,
	size = 1,
	texture = "climatez_rain.png",
})

register_downfall("snow", {
	min_pos = {x = -15, y = 10, z= -15},
	max_pos = {x = 15, y = 10, z = 15},
	falling_speed = 5,
	amount = 15,
	exptime = 7,
	size = 1,
	texture= "climatez_snow.png",
})

register_downfall("sand", {
	min_pos = {x = -20, y = -4, z = -20},
	max_pos = {x = 20, y = 4, z = 20},
	falling_speed = -1,
	amount = 25,
	exptime = 1,
	size = 4,
	texture = "climatez_sand.png",
})

--WIND STUFF

local function create_wind()
	local wind = {
		x = math.random(0,5),
		y = 0,
		z = math.random(0,5)
	}
	return wind
end

function get_player_wind(player)
	local player_pos = player:get_pos()
	local climate_id = player_inside_climate(player_pos)
	if climate_id then
		return climatez.climates[climate_id].wind
	else
		return create_wind()
	end
end

--LIGHTING

local function show_lightning(player)
	local hud_id = player:hud_add({
		hud_elem_type = "image",
		text = "climatez_lightning.png",
		position = {x=0, y=0},
		scale = {x=-100, y=-100},
		alignment = {x=1, y=1},
		offset = {x=0, y=0}
	})
	--save the lightning per player, NOT per climate
	player:get_meta():set_int("climatez:lightning", hud_id)
	if climatez.settings.thunder_sound then
		local player_name = player:get_player_name()
		minetest.sound_play("climatez_thunder", {
			to_player = player_name,
			loop = false,
			gain = 1.0,
		})
	end
end

local function remove_lightning(player)
	local meta = player:get_meta()
	local hud_id = meta:get_int("climatez:lightning")
	player:hud_remove(hud_id)
	meta:set_int("climatez:lightning", -1)
end

--CLIMATE FUNCTIONS

local function get_id()
	local id
	--search for a free position
	for i= 1, (#climatez.climates+1) do
		if not climatez.climates[i] then
			id = i
			break
		end
	end
	return id
end

local function add_climate_player(player, _climate_id, _downfall)
	local player_name = player:get_player_name()
	climatez.players[player_name] = {
		climate_id = _climate_id,
		downfall = _downfall,
		sky_color = nil,
		clouds_color = nil,
		rain_sound_handle = nil,
	}
	local downfall_sky_color, downfall_clouds_color
	if _downfall == "rain" or _downfall == "storm" or _downfall == "snow" then
		downfall_sky_color = "#808080"
		downfall_clouds_color = "#C0C0C0"
	else --"sand"
		downfall_sky_color = "#DEB887"
		downfall_clouds_color = "#DEB887"
	end
	climatez.players[player_name].sky_color = player:get_sky().sky_color or "#8cbafa"
	player:set_sky({
		sky_color = {
			day_sky = downfall_sky_color,
		}
	})
	climatez.players[player_name].clouds_color = player:get_clouds().color or "#fff0f0e5"
	player:set_clouds({
		color = downfall_clouds_color,
	})

	if climatez.settings.climate_rain_sound and (_downfall == "rain" or _downfall == "storm") then
		local rain_sound_handle = minetest.sound_play("climatez_rain", {
			to_player = player_name,
			loop = true,
			gain = 1.0,
		})
		climatez.players[player_name].rain_sound_handle = rain_sound_handle
	end
end

local function remove_climate_player(player)
	local player_name = player:get_player_name()
	player:set_sky({
		sky_color = {
			day_sky = climatez.players[player_name].sky_color,
		}
	})
	player:set_clouds({
		color = climatez.players[player_name].clouds_color,
	})
	local downfall = climatez.players[player_name].downfall
	local rain_sound_handle = climatez.players[player_name].rain_sound_handle
	if rain_sound_handle and climatez.settings.climate_rain_sound
		and (downfall == "rain" or downfall == "storm") then
			minetest.sound_stop(rain_sound_handle)
	end

	local lightning = player:get_meta():get_int("climatez:lightning")
	if downfall == "storm" and lightning > 0 then
		remove_lightning(player)
	end

	--remove the player-->
	climatez.players = remove_table_by_key(climatez.players, player_name)
end

local function remove_climate(climate_id)
	--remove the players
	for _player_name, _climate in pairs(climatez.players) do
		local _climate_id = _climate.climate_id
		if _climate_id == climate_id then
			local _player = minetest.get_player_by_name(_player_name)
			if _player then
				remove_climate_player(_player)
				--minetest.chat_send_all(_player_name.." removed from climate")
			end
		end
	end
	--disable the climate, but do not remove it
	climatez.climates[climate_id].disabled = true
	--remove the climate after the period time:
	minetest.after(climatez.settings.climate_period, function()
		--minetest.chat_send_all("end of the climate")
		climatez.climates = remove_table_by_key(climatez.climates, climate_id)
		--minetest.chat_send_all("Removed climate, id="..tostring(climate_id))
	end, climate_id)
end

local function create_climate(player)
	--get some data
	local player_pos = player:get_pos()
	local biome_data = minetest.get_biome_data(player_pos)
	local biome_heat = biome_data.heat
	local biome_humidity = biome_data.humidity

	local downfall

	if biome_heat >= 20 and biome_humidity >= 50 then
		local chance = math.random(climatez.settings.storm_chance)
		if chance == 1 then
			downfall = "storm"
		else
			downfall = "rain"
		end
	elseif biome_heat >= 50 and biome_humidity <= 20  then
		downfall = "sand"
	elseif biome_heat < 20 then
		downfall = "snow"
	end

	if not downfall then
		return
	end

	--create wind
	local wind = create_wind()

	--strong wind if a storm
	if downfall == "storm" then
		wind = {
			x = wind.x * 2,
			y = wind.y,
			z = wind.z * 2,
		}
	end

	--very strong wind if a sandstorm
	if downfall == "sand" then
		if wind.x < 1 then
			wind.x = 1
			wind.y = 1
		end
		wind = {
			x = wind.x * 5,
			y = wind.y,
			z = wind.z * 5,
		}
	end

	--create climate
	local climate_id = get_id()
	--minetest.chat_send_all(tostring(climate_id))
	climatez.climates[climate_id] = {
		--A disabled climate is a not removed climate,
		--but inactive, so another climate changes are not allowed yet.
		disabled = false,
		center = player_pos,
		downfall = downfall,
		wind = wind,
	}

	--save the player
	add_climate_player(player, climate_id, downfall)

	--program climate's end
	local climate_duration = climatez.settings.climate_duration
	local climate_duration_random_ratio = climatez.settings.duration_random_ratio
	local random_end_time = (math.random(climate_duration - (climate_duration*climate_duration_random_ratio),
		climate_duration + (climate_duration*climate_duration_random_ratio)))

	--remove the climate
	minetest.after(random_end_time, remove_climate, climate_id)

	--minetest.chat_send_all("Created a climate, id="..tostring(climate_id))
end

local timer = 0

local function apply_climate(player, climate_id)

	local player_pos = player:get_pos()
	local climate = climatez.climates[climate_id]
	if not climate then
		remove_climate_player(player)
		return
	end
	local player_name = player:get_player_name()
	local player_downfall = climatez.players[player_name].downfall
	local downfall = climatez.registered_downfalls[player_downfall]
	local wind = climate.wind
	local wind_pos = vector.multiply(wind, -1)
	local minp = vector.add(vector.add(player_pos, downfall.min_pos), wind_pos)
	local maxp = vector.add(vector.add(player_pos, downfall.max_pos), wind_pos)

	--Check if in player in interiors or not
	if check_light and not has_light(minp, maxp) then
		return
	end

	local vel = {x = wind.x, y = - downfall.falling_speed, z = wind.z}
	local acc = {x = 0, y = 0, z = 0}
	local exp = downfall.exptime

	minetest.add_particlespawner({
		amount = downfall.amount, time=0.5,
		minpos = minp, maxpos = maxp,
		minvel = vel, maxvel = vel,
		minacc = acc, maxacc = acc,
		minexptime = exp, maxexptime = exp,
		minsize = downfall.size, maxsize= downfall.size,
		collisiondetection = true, collision_removal = true,
		vertical = true,
		texture = downfall.texture, playername = player:get_player_name()
	})

	--Lightning
	if player_downfall == "storm" and climatez.settings.lightning then
		local lightning = player:get_meta():get_int("climatez:lightning")
		--minetest.chat_send_all(tostring(lightning))
		--minetest.chat_send_all(tonumber(timer))
		if timer >= 0.5 then
			if lightning <= 0  then
				local chance = math.random(climatez.settings.lightning_chance)
				if chance == 1 then
					show_lightning(player, climate_id)
				end
			end
		end
		if timer >= 0.1 and lightning > 0 then
			remove_lightning(player)
		end
	end
end

--CLIMATE CORE: GLOBALSTEP

minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 1 then
		for _, player in ipairs(minetest.get_connected_players()) do
			local _player_name = player:get_player_name()
			local player_pos = player:get_pos()
			local climate_id, climate_disabled = player_inside_climate(player_pos)
			local _climate = climatez.players[_player_name]
			if climate_id and _climate then --if already in a climate, check if still inside it
				local _climate_id = _climate.climate_id
				if not climate_id == _climate_id then
					remove_climate_player(player)
				end
			elseif climate_id and not(_climate) and not climate_disabled then --another player enter into the climate
				local downfall = climatez.climates[climate_id].downfall
				add_climate_player(player, climate_id, downfall)
				--minetest.chat_send_all(_player_name.." entered into the climate")
			else --chance to create a climate
				if not climate_disabled then --if not in a disabled climate
					local chance = math.random(climatez.settings.climate_change_ratio)
					if chance == 1 then
						create_climate(player)
					end
				end
			end
		end
		timer = 0
	end
	--Apply the climates to the players with climate defined
	for _player_name, _climate in pairs(climatez.players) do
		local player = minetest.get_player_by_name(_player_name)
		if player and _climate then
			local _climate_id = _climate.climate_id
			apply_climate(player, _climate_id)
		else
			--Do not use "remove_climate_player" here, because the player could
			--had abandoned the game; better remove it directly
			climatez.players = remove_table_by_key(climatez.players, _player_name)
			--minetest.chat_send_all(_player_name.." test")
		end
	end
end)
