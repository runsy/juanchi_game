local path = minetest.get_modpath("emeralds")
local modpath = path .. "/emeralds.lua"
assert(loadfile(modpath))(path, modpath)