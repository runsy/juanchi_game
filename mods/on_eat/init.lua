minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)

		local hp = user:get_hp()
		--if hp >= 20 then return itemstack end
			
		
		local pos = user:getpos()
		pos.y = pos.y + 1.53
		local itemname = itemstack:get_name()
		local texture  = minetest.registered_items[itemname].inventory_image
		local dir = user:get_look_dir()


		minetest.add_particlespawner({
			amount = 1,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = {x = dir.x - 1, y = dir.y, z = dir.z - 1},
			maxvel = {x = dir.x + 1, y = dir.y, z = dir.z + 1},
			minacc = {x = 0, y = -5, z = 0},
			maxacc = {x = 0, y = -9, z = 0},
			minexptime = 0.3,
			maxexptime = 0.5,
			minsize = 1.5,
			maxsize = 3,
			texture = "eat_particles.png^"..texture.."^eat_particles.png^[makealpha:255,126,126",

		})

		minetest.add_particlespawner({
			amount = 1,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = {x = dir.x - 1, y = dir.y, z = dir.z - 1},
			maxvel = {x = dir.x + 1, y = dir.y, z = dir.z + 1},
			minacc = {x = 0, y = -5, z = 0},
			maxacc = {x = 0, y = -9, z = 0},
			minexptime = 0.3,
			maxexptime = 0.5,
			minsize = 1.5,
			maxsize = 3,

			texture = "eat_particles.png^"..texture.."^(eat_particles.png^[transformR180)^[makealpha:255,126,126",

		})
		
		minetest.add_particlespawner({
			amount = 1,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = {x = dir.x - 1, y = dir.y, z = dir.z - 1},
			maxvel = {x = dir.x + 1, y = dir.y, z = dir.z + 1},
			minacc = {x = 0, y = -5, z = 0},
			maxacc = {x = 0, y = -9, z = 0},
			minexptime = 0.3,
			maxexptime = 0.5,
			minsize = 1.5,
			maxsize = 3,

			texture = "eat_particles.png^"..texture.."^(eat_particles.png^[transformR90)^[makealpha:255,126,126",

		})
		
		minetest.add_particlespawner({
			amount = 1,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = {x = dir.x - 1, y = dir.y, z = dir.z - 1},
			maxvel = {x = dir.x + 1, y = dir.y, z = dir.z + 1},
			minacc = {x = 0, y = -5, z = 0},
			maxacc = {x = 0, y = -9, z = 0},
			minexptime = 0.3,
			maxexptime = 0.5,
			minsize = 1.5,
			maxsize = 3,

			texture = "eat_particles.png^"..texture.."^(eat_particles.png^[transformR270)^[makealpha:255,126,126",

		})

		minetest.add_particlespawner({
			amount = 1,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = {x = dir.x - 1, y = dir.y, z = dir.z - 1},
			maxvel = {x = dir.x + 1, y = dir.y, z = dir.z + 1},
			minacc = {x = 0, y = -5, z = 0},
			maxacc = {x = 0, y = -9, z = 0},
			minexptime = 0.3,
			maxexptime = 0.5,
			minsize = 1.5,
			maxsize = 3,

			texture = "eat_particles.png^"..texture.."^(eat_particles.png^[transformFX)^[makealpha:255,126,126",

		})

		minetest.add_particlespawner({
			amount = 1,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = {x = dir.x - 1, y = dir.y, z = dir.z - 1},
			maxvel = {x = dir.x + 1, y = dir.y, z = dir.z + 1},
			minacc = {x = 0, y = -5, z = 0},
			maxacc = {x = 0, y = -9, z = 0},
			minexptime = 0.3,
			maxexptime = 0.5,
			minsize = 1.5,
			maxsize = 3,

			texture = "eat_particles.png^"..texture.."^(eat_particles.png^[transformFXR180)^[makealpha:255,126,126",

		})
		
		minetest.add_particlespawner({
			amount = 1,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = {x = dir.x - 1, y = dir.y, z = dir.z - 1},
			maxvel = {x = dir.x + 1, y = dir.y, z = dir.z + 1},
			minacc = {x = 0, y = -5, z = 0},
			maxacc = {x = 0, y = -9, z = 0},
			minexptime = 0.3,
			maxexptime = 0.5,
			minsize = 1.5,
			maxsize = 3,

			texture = "eat_particles.png^"..texture.."^(eat_particles.png^[transformFXR90)^[makealpha:255,126,126",

		})
		
		minetest.add_particlespawner({
			amount = 1,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = {x = dir.x - 1, y = dir.y, z = dir.z - 1},
			maxvel = {x = dir.x + 1, y = dir.y, z = dir.z + 1},
			minacc = {x = 0, y = -5, z = 0},
			maxacc = {x = 0, y = -9, z = 0},
			minexptime = 0.3,
			maxexptime = 0.5,
			minsize = 1.5,
			maxsize = 3,

			texture = "eat_particles.png^"..texture.."^(eat_particles.png^[transformFXR270)^[makealpha:255,126,126",

		})
		
			
			
end)
