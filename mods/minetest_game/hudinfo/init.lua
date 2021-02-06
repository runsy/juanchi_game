local S = minetest.get_translator(minetest.get_current_modname())

local hbinfo = {}
hbinfo.players = {}

minetest.register_on_leaveplayer(function(player)
	hbinfo.players[player:get_player_name()] = nil
end)

local biome_description = {
	grassland = S("Grassland"),
	coniferous_forest = S("Coniferous forest"),
	deciduous_forest = S("Deciduous forest"),
	rainforest = S("Rainforest"),
	savanna = S("Savanna"),
	desert = S("Desert"),
	sandstone_desert = S("Sandstone desert"),
	cold_desert = S("Cold desert"),
	snowy_grassland = S("Snowy grassland"),
	taiga = S("Taiga"),
	tundra = S("Tundra"),
	ice_sheet  = S("Ice Sheet"),
	grassland_dunes = S("Grassland dunes"),
	coniferous_forest_dunes = S("Coniferous forest dunes"),
	deciduous_forest_shore = S("Deciduous forest shore"),
	rainforest_swamp = S("Rainforest swamp"),
	savanna_shore = S("Savanna shore"),
	taiga_beach = S("Taiga beach"),
	tundra_beach = S("Tundra beach"),
	tundra_ocean = S("Tundra ocean"),
	snowy_grassland_ocean = S("Snowy grassland ocean"),
	grassland_ocean = S("Grassland ocean"),
	coniferous_forest_ocean = S("Coniferous forest ocean"),
	deciduous_forest_ocean = S("Deciduous forest ocean"),
	cold_desert_ocean = S("Cold desert ocean"),
	sandstone_desert_ocean = S("Sandstone desert ocean"),
	savanna_ocean = S("Savanna ocean"),
	rainforest_ocean = S("Rainforest ocean"),
	desert_ocean = S("Desert ocean"),
	ice_sheet_ocean = S("Ice sheet ocean"),
	swampz = S("Swamp"),
	swampz_shore = S("Swampz shore"),
	temperate_rainforest = S("Temperate rainforest"),
}

local function get_biome_name(player)
	local biome_name = minetest.get_biome_name(minetest.get_biome_data(player:get_pos()).biome)
	return biome_description[biome_name] or biome_name or ""
end

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	local _biome_name = get_biome_name(player)
	local _idx = player:hud_add({
		hud_elem_type = "text",
		number = "0xFFFFFF",
		position = {x = 0, y = 1},
		text = _biome_name,
		alignment = {x = 1, y = -1},
		scale = {x = 100, y = 100},
	})
	hbinfo.players[player_name] = {idx = _idx, biome_name = _biome_name}
end)

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime;
	if timer >= 1 then
		for _, player in pairs(minetest.get_connected_players()) do
			local biome_name = get_biome_name(player)
			local player_name = player:get_player_name()
			if not(biome_name == hbinfo.players[player_name].biome_name) then
				hbinfo.players[player_name].biome_name = biome_name
				player:hud_change(hbinfo.players[player_name].idx, "text", get_biome_name(player))
			end
		end
		timer = 0
	end
end)



