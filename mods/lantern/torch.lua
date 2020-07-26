minetest.override_item("default:torch", {
	tiles = {
		{name = "default_torch_new_top.png",    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.0}},
		{name = "default_torch_new_bottom.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.0}},
		{name = "default_torch_new_side.png",   animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.0}},
	},
	inventory_image = "default_torch_new_inv.png",
	wield_image = "default_torch_new_inv.png",
	wield_scale = {x = 1, y = 1, z = 1.25},
	drawtype = "nodebox",
	node_box = {
		type = "wallmounted",
		wall_top    = {-0.0625, -0.0625, -0.0625, 0.0625, 0.5   , 0.0625},
		wall_bottom = {-0.0625, -0.5   , -0.0625, 0.0625, 0.0625, 0.0625},
		wall_side   = {-0.5   , -0.5   , -0.0625, -0.375, 0.0625, 0.0625},
	},
})
