local modpath, S = ...

assert(loadfile(modpath .. "/mobkit/bh_ant.lua"))(modpath)
assert(loadfile(modpath .. "/mobkit/bh_aquatic.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/bh_arboreal.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/bh_attack.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/bh_bee.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/bh_breed.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/bh_fly.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/bh_follow.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/bh_herding.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/bh_hunt.lua"))()
assert(loadfile(modpath .. "/mobkit/bh_mount.lua"))()
assert(loadfile(modpath .. "/mobkit/bh_replace.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/bh_runaway.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/bh_teleport.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/bh_torch.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/br_ant.lua"))()
assert(loadfile(modpath .. "/mobkit/br_aquatic.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/br_bee.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/br_herbivore.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/br_monster.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/br_predator.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/br_semiaquatic.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/helper_functions.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit/bh_head.lua"))(modpath, S)
