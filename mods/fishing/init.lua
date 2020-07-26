local modname = "fishing"

local modpath = minetest.get_modpath(modname)

-- Load support for intllib.
local S = minetest.get_translator(minetest.get_current_modname())

assert(loadfile(modpath .. "/fishing.lua"))(modpath, S)
