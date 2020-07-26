-- tree_stairs
-- See LICENSE.md for licensing and other information.


-- Global namespace for functions

tree_stairs = {}

-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

-- Register aliases for new pine node names

minetest.register_alias("tree_stairs:stair_pinewood", "tree_stairs:stair_pine_wood")
minetest.register_alias("tree_stairs:slab_pinewood", "tree_stairs:slab_pine_wood")


-- Get setting for replace ABM

local replace = minetest.settings:get_bool("enable_stairs_replace_abm")

local function rotate_and_place(itemstack, placer, pointed_thing)
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local param2 = 0

	if placer then
		local placer_pos = placer:get_pos()
		if placer_pos then
			param2 = minetest.dir_to_facedir(vector.subtract(p1, placer_pos))
		end

		local finepos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
		local fpos = finepos.y % 1

		if p0.y - 1 == p1.y or (fpos > 0 and fpos < 0.5)
				or (fpos < -0.5 and fpos > -0.999999999) then
			param2 = param2 + 20
			if param2 == 21 then
				param2 = 23
			elseif param2 == 23 then
				param2 = 21
			end
		end
	end
	return minetest.item_place(itemstack, placer, pointed_thing, param2)
end


-- Register stair
-- Node will be called stairs:stair_<subname>

function tree_stairs.register_stair(subname, recipeitem, groups, images, description,
		sounds, worldaligntex)
	-- Set backface culling and world-aligned textures
	local stair_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			stair_images[i] = {
				name = image,
				backface_culling = true,
			}
			if worldaligntex then
				stair_images[i].align_style = "world"
			end
		else
			stair_images[i] = table.copy(image)
			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end
			if worldaligntex and stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.stair = 1
	minetest.register_node(":tree_stairs:stair_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			return rotate_and_place(itemstack, placer, pointed_thing)
		end,
	})

	-- for replace ABM
	if replace then
		minetest.register_node(":tree_stairs:stair_" .. subname .. "upside_down", {
			replace_name = "tree_stairs:stair_" .. subname,
			groups = {slabs_replace = 1},
		})
	end

	if recipeitem then
		-- Recipe matches appearence in inventory
		minetest.register_craft({
			output = 'tree_stairs:stair_' .. subname .. ' 8',
			recipe = {
				{"", "", recipeitem},
				{"", recipeitem, recipeitem},
				{recipeitem, recipeitem, recipeitem},
			},
		})

		-- Use stairs to craft full blocks again (1:1)
		minetest.register_craft({
			output = recipeitem .. ' 3',
			recipe = {
				{'tree_stairs:stair_' .. subname, 'tree_stairs:stair_' .. subname},
				{'tree_stairs:stair_' .. subname, 'tree_stairs:stair_' .. subname},
			},
		})

		-- Fuel
		local baseburntime = minetest.get_craft_result({
			method = "fuel",
			width = 1,
			items = {recipeitem}
		}).time
		if baseburntime > 0 then
			minetest.register_craft({
				type = "fuel",
				recipe = 'tree_stairs:stair_' .. subname,
				burntime = math.floor(baseburntime * 0.75),
			})
		end
	end
end


-- Register slab
-- Node will be called stairs:slab_<subname>

function tree_stairs.register_slab(subname, recipeitem, groups, images, description,
		sounds, worldaligntex)
	-- Set world-aligned textures
	local slab_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			slab_images[i] = {
				name = image,
			}
			if worldaligntex then
				slab_images[i].align_style = "world"
			end
		else
			slab_images[i] = table.copy(image)
			if worldaligntex and image.align_style == nil then
				slab_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.slab = 1
	minetest.register_node(":tree_stairs:slab_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = slab_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_place = function(itemstack, placer, pointed_thing)
			local under = minetest.get_node(pointed_thing.under)
			local wield_item = itemstack:get_name()
			local player_name = placer and placer:get_player_name() or ""
			local creative_enabled = (creative and creative.is_enabled_for
					and creative.is_enabled_for(player_name))

			if under and under.name:find("^tree_stairs:slab_") then
				-- place slab using under node orientation
				local dir = minetest.dir_to_facedir(vector.subtract(
					pointed_thing.above, pointed_thing.under), true)

				local p2 = under.param2

				-- Placing a slab on an upside down slab should make it right-side up.
				if p2 >= 20 and dir == 8 then
					p2 = p2 - 20
				-- same for the opposite case: slab below normal slab
				elseif p2 <= 3 and dir == 4 then
					p2 = p2 + 20
				end

				-- else attempt to place node with proper param2
				minetest.item_place_node(ItemStack(wield_item), placer, pointed_thing, p2)
				if not creative_enabled then
					itemstack:take_item()
				end
				return itemstack
			else
				return rotate_and_place(itemstack, placer, pointed_thing)
			end
		end,
	})

	-- for replace ABM
	if replace then
		minetest.register_node(":tree_stairs:slab_" .. subname .. "upside_down", {
			replace_name = "tree_stairs:slab_".. subname,
			groups = {slabs_replace = 1},
		})
	end

	if recipeitem then
		minetest.register_craft({
			output = 'tree_stairs:slab_' .. subname .. ' 6',
			recipe = {
				{recipeitem, recipeitem, recipeitem},
			},
		})

		-- Use 2 slabs to craft a full block again (1:1)
		minetest.register_craft({
			output = recipeitem,
			recipe = {
				{'tree_stairs:slab_' .. subname},
				{'tree_stairs:slab_' .. subname},
			},
		})

		-- Fuel
		local baseburntime = minetest.get_craft_result({
			method = "fuel",
			width = 1,
			items = {recipeitem}
		}).time
		if baseburntime > 0 then
			minetest.register_craft({
				type = "fuel",
				recipe = 'tree_stairs:slab_' .. subname,
				burntime = math.floor(baseburntime * 0.5),
			})
		end
	end
end


-- Optionally replace old "upside_down" nodes with new param2 versions.
-- Disabled by default.

if replace then
	minetest.register_abm({
		label = "Slab replace",
		nodenames = {"group:slabs_replace"},
		interval = 16,
		chance = 1,
		action = function(pos, node)
			node.name = minetest.registered_nodes[node.name].replace_name
			node.param2 = node.param2 + 20
			if node.param2 == 21 then
				node.param2 = 23
			elseif node.param2 == 23 then
				node.param2 = 21
			end
			minetest.set_node(pos, node)
		end,
	})
end


-- Register inner stair
-- Node will be called stairs:stair_inner_<subname>

function tree_stairs.register_stair_inner(subname, recipeitem, groups, images,
		description, sounds, worldaligntex)
	-- Set backface culling and world-aligned textures
	local stair_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			stair_images[i] = {
				name = image,
				backface_culling = true,
			}
			if worldaligntex then
				stair_images[i].align_style = "world"
			end
		else
			stair_images[i] = table.copy(image)
			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end
			if worldaligntex and stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.stair = 1
	minetest.register_node(":tree_stairs:stair_inner_" .. subname, {
		description = S("Inner").. " " .. description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
				{-0.5, 0.0, -0.5, 0.0, 0.5, 0.0},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			return rotate_and_place(itemstack, placer, pointed_thing)
		end,
	})

	if recipeitem then
		minetest.register_craft({
			output = 'tree_stairs:stair_inner_' .. subname .. ' 7',
			recipe = {
				{ "", recipeitem, ""},
				{ recipeitem, "", recipeitem},
				{recipeitem, recipeitem, recipeitem},
			},
		})

		-- Fuel
		local baseburntime = minetest.get_craft_result({
			method = "fuel",
			width = 1,
			items = {recipeitem}
		}).time
		if baseburntime > 0 then
			minetest.register_craft({
				type = "fuel",
				recipe = 'tree_stairs:stair_inner_' .. subname,
				burntime = math.floor(baseburntime * 0.875),
			})
		end
	end
end


-- Register outer stair
-- Node will be called stairs:stair_outer_<subname>

function tree_stairs.register_stair_outer(subname, recipeitem, groups, images,
		description, sounds, worldaligntex)
	-- Set backface culling and world-aligned textures
	local stair_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			stair_images[i] = {
				name = image,
				backface_culling = true,
			}
			if worldaligntex then
				stair_images[i].align_style = "world"
			end
		else
			stair_images[i] = table.copy(image)
			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end
			if worldaligntex and stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.stair = 1
	minetest.register_node(":tree_stairs:stair_outer_" .. subname, {
		description = S("Outer").. " " .. description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.0, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			return rotate_and_place(itemstack, placer, pointed_thing)
		end,
	})

	if recipeitem then
		minetest.register_craft({
			output = 'tree_stairs:stair_outer_' .. subname .. ' 6',
			recipe = {
				{ "", "", ""},
				{ "", recipeitem, ""},
				{recipeitem, recipeitem, recipeitem},
			},
		})

		-- Fuel
		local baseburntime = minetest.get_craft_result({
			method = "fuel",
			width = 1,
			items = {recipeitem}
		}).time
		if baseburntime > 0 then
			minetest.register_craft({
				type = "fuel",
				recipe = 'tree_stairs:stair_outer_' .. subname,
				burntime = math.floor(baseburntime * 0.625),
			})
		end
	end
end


-- Stair/slab registration function.
-- Nodes will be called stairs:{stair,slab}_<subname>

function tree_stairs.register_stair_and_slab(subname, recipeitem, groups, images,
		desc_stair, desc_slab, sounds, worldaligntex)
	tree_stairs.register_stair(subname, recipeitem, groups, images, desc_stair,
		sounds, worldaligntex)
	tree_stairs.register_stair_inner(subname, recipeitem, groups, images, desc_stair,
		sounds, worldaligntex)
	tree_stairs.register_stair_outer(subname, recipeitem, groups, images, desc_stair,
		sounds, worldaligntex)
	tree_stairs.register_slab(subname, recipeitem, groups, images, desc_slab,
		sounds, worldaligntex)
end



tree_stairs.register_stair(
	"acacia_tree",
	"default:acacia_tree",
	{cracky = 3},
	{"default_acacia_tree_top.png", "default_acacia_tree_top.png",
	"default_acacia_tree.png", "default_acacia_tree.png",
	"default_acacia_tree.png", "ts_acacia_tree_front.png"},
	S("Acacia Tree Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_slab(
	"acacia_tree",
	"default:acacia_tree",
	{cracky = 3},
	{"default_acacia_tree_top.png", "default_acacia_tree_top.png", "default_acacia_tree.png",},
	S("Acacia Tree Slab"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair_inner(
	"acacia_tree",
	"default:acacia_tree",
	{cracky = 3},
	{"default_acacia_tree_top.png", "default_acacia_tree_top.png",
	"ts_acacia_tree_front_right.png", "default_acacia_tree.png",
	"default_acacia_tree.png", "ts_acacia_tree_front_right.png^[transformFX"},
	S("Acacia Tree Inner Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair_outer(
	"acacia_tree",
	"default:acacia_tree",
	{cracky = 3},
	{"default_acacia_tree_top.png", "default_acacia_tree_top.png",
	"ts_acacia_tree_front.png", "default_acacia_tree.png",
	"default_acacia_tree.png", "ts_acacia_tree_front.png"},
	S("Acacia Tree Outer Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair(
	"apple_tree",
	"default:tree",
	{cracky = 3},
	{"default_tree_top.png", "default_tree_top.png",
	"default_tree.png", "default_tree.png",
	"default_tree.png", "ts_tree_front.png"},
	S("Apple Tree Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_slab(
	"apple_tree",
	"default:tree",
	{cracky = 3},
	{"default_tree_top.png", "default_tree_top.png", "default_tree.png",},
	S("Apple Tree Slab"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair_inner(
	"apple_tree",
	"default:tree",
	{cracky = 3},
	{"default_tree_top.png", "default_tree_top.png",
	"ts_tree_front_right.png", "default_tree.png",
	"default_tree.png", "ts_tree_front_right.png^[transformFX"},
	S("Apple Tree Inner Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair_outer(
	"apple_tree",
	"default:tree",
	{cracky = 3},
	{"default_tree_top.png", "default_tree_top.png",
	"ts_tree_front.png", "default_tree.png",
	"default_tree.png", "ts_tree_front.png"},
	S("Apple Tree Outer Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair(
	"aspen_tree",
	"default:aspen_tree",
	{cracky = 3},
	{"default_aspen_tree_top.png", "default_aspen_tree_top.png",
	"default_aspen_tree.png", "default_aspen_tree.png",
	"default_aspen_tree.png", "ts_aspen_tree_front.png"},
	S("Aspen Tree Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_slab(
	"aspen_tree",
	"default:tree",
	{cracky = 3},
	{"default_aspen_tree_top.png", "default_aspen_tree_top.png", "default_aspen_tree.png",},
	S("Aspen Tree Slab"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair_inner(
	"aspen_tree",
	"default:aspen_tree",
	{cracky = 3},
	{"default_aspen_tree_top.png", "default_aspen_tree_top.png",
	"ts_aspen_tree_front_right.png", "default_aspen_tree.png",
	"default_aspen_tree.png", "ts_aspen_tree_front_right.png^[transformFX"},
	S("Aspen Tree Inner Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair_outer(
	"aspen_tree",
	"default:aspen_tree",
	{cracky = 3},
	{"default_aspen_tree_top.png", "default_aspen_tree_top.png",
	"ts_aspen_tree_front.png", "default_aspen_tree.png",
	"default_aspen_tree.png", "ts_aspen_tree_front.png"},
	S("Aspen Tree Outer Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair(
	"jungletree",
	"default:jungletree_",
	{cracky = 3},
	{"default_jungletree_top.png", "default_jungletree_top.png",
	"default_jungletree.png", "default_jungletree.png",
	"default_jungletree.png", "ts_jungletree_front.png"},
	S("Jungletree Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_slab(
	"jungletree",
	"default:jungletree",
	{cracky = 3},
	{"default_jungletree_top.png", "default_jungletree_top.png", "default_jungletree.png",},
	S("Jungletree Slab"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair_inner(
	"jungletree",
	"default:jungletree",
	{cracky = 3},
	{"default_jungletree_top.png", "default_jungletree_top.png",
	"ts_jungletree_front_right.png", "default_jungletree.png",
	"default_jungletree.png", "ts_jungletree_front_right.png^[transformFX"},
	S("Jungletree Inner Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair_outer(
	"jungletree",
	"default:jungletree",
	{cracky = 3},
	{"default_jungletree_top.png", "default_jungletree_top.png",
	"ts_jungletree_front.png", "default_jungletree.png",
	"default_jungletree.png", "ts_jungletree_front.png"},
	S("Jungletree Outer Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair(
	"pine_tree",
	"default:pine_tree",
	{cracky = 3},
	{"default_pine_tree_top.png", "default_pine_tree_top.png",
	"default_pine_tree.png", "default_pine_tree.png",
	"default_pine_tree.png", "ts_pine_tree_front.png"},
	S("Pine Tree Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_slab(
	"pine_tree",
	"default:pine_tree",
	{cracky = 3},
	{"default_pine_tree_top.png", "default_pine_tree_top.png", "default_pine_tree.png",},
	S("Pine Tree Slab"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair_inner(
	"pine_tree",
	"default:tree",
	{cracky = 3},
	{"default_pine_tree_top.png", "default_pine_tree_top.png",
	"ts_pine_tree_front_right.png", "default_pine_tree.png",
	"default_pine_tree.png", "ts_pine_tree_front_right.png^[transformFX"},
	S("Pine Tree Inner Stair"),
	default.node_sound_wood_defaults(),
	false
)

tree_stairs.register_stair_outer(
	"pine_tree",
	"default:pine_tree",
	{cracky = 3},
	{"default_pine_tree_top.png", "default_pine_tree_top.png",
	"ts_pine_tree_front.png", "default_pine_tree.png",
	"default_pine_tree.png", "ts_pine_tree_front.png"},
	S("Pine Tree Outer Stair"),
	default.node_sound_wood_defaults(),
	false
)
