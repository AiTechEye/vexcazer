vexcazer_extras={
	nodes={},
}

for i,v in ipairs({"FFFFFF","FF0000","ff009c","ff7700","00cbff","00FF00","0000FF","000000","8bb9f9"}) do
minetest.register_node("vexcazer_extras:glowing_" ..v, {
	description = "Glowing block",
	drawtype="glasslike",
	tiles = {"gui_hb_bg.png^[colorize:#" ..  v},
	light_source = 14,
	paramtype = "light",
	sunlight_propagates = true,
	groups={cracky=3},
})

table.insert(vexcazer_extras.nodes,"vexcazer_extras:unbreakable_glowing_" ..v)
minetest.register_node("vexcazer_extras:unbreakable_glowing_" ..v, {
	description = "Unbreakable Glowing block",
	stack_max=1000,
	drop="",
	drawtype="glasslike",
	tiles = {"gui_hb_bg.png^[colorize:#" ..  v},
	light_source = 14,
	paramtype = "light",
	sunlight_propagates = true,
	groups={not_in_creative_inventory=1,unbreakable=1},
})

end

for i,v in pairs(minetest.registered_nodes) do
	local def=minetest.registered_nodes[i]
	if def and def.mod_origin=="default" and (def.drawtype=="normal" or def.drawtype=="glasslike_framed_optional" or def.drawtype=="glasslike") then
		local newdef=table.copy(def)
		local name="vexcazer_extras:unbreakable_" .. v.name:sub(v.name:find(":")+1,v.name:len())
		newdef.description="Unbreakable " .. def.description
		newdef.drop=""
		newdef.groups = {not_in_creative_inventory=1,unbreakable=1}
		newdef.stack_max=1000
		minetest.register_node(name, newdef)
		table.insert(vexcazer_extras.nodes,name)
	end
end




vexcazer.registry_mode({
	name="Unbreakable",
	info="Unbreakable blocks",
	disallow_damage_on_use=true,
	hide_mode_default=true,
	hide_mode_mod=true,
	on_button=function(user,input)
		local gui="size[20,10]"
		local x=0
		local y=0
		for i,name in pairs(vexcazer_extras.nodes) do
			gui=gui .. "item_image_button[" .. x.. ",".. y..";1,1;" .. name ..";" ..  name .. ";]"
			x=x+1
			if x>19 then
				y=y+1
				x=0
			end
		end
		minetest.after(0.1, function()
			return minetest.show_formspec(user:get_player_name(), "vexcazer_extras:unbreakable",gui)
		end)
	end,
})

minetest.register_on_player_receive_fields(function(player, form, pressed)
	if form=="vexcazer_extras:unbreakable" and not pressed.quit then
		local name=""
		for k,v in pairs(pressed) do
			name=k
			break
		end
		player:get_inventory():add_item("main", name .." 100")
	end
end)

table.insert(vexcazer_extras.nodes,"vexcazer_extras:black")
minetest.register_node("vexcazer_extras:black", {
	description = "Black",
	stack_max=1000,
	drawtype="glasslike",
	tiles = {"gui_hb_bg.png^[colorize:#000000"},
	drop="",
	walkable=false,
	damage_per_second=100,
	groups = {not_in_creative_inventory=1},
})
table.insert(vexcazer_extras.nodes,"vexcazer_extras:collision")
minetest.register_node("vexcazer_extras:collision", {
	description = "Collision",
	stack_max=1000,
	drawtype="airlike",
	drop="",
	paramtype = "light",
	sunlight_propagates = true,
	pointable=false,
	groups = {not_in_creative_inventory=1},
})

if minetest.get_modpath("mesecons") then
table.insert(vexcazer_extras.nodes,"vexcazer_extras:collision_mese")
minetest.register_node("vexcazer_extras:collision_mese", {
	description = "Collision mesecon effected",
	stack_max=1000,
	inventory_image="default_mese_block.png",
	drawtype="airlike",
	drop="",
	paramtype = "light",
	sunlight_propagates = true,
	pointable=false,
	groups = {not_in_creative_inventory=1},
	mesecons = {conductor = {
		state = mesecon.state.off,
		onstate = "vexcazer_extras:collision_mese_off",
		rules={{x=1,y=0,z=0},{x=-1,y=0,z=0},{x=0,y=1,z=0},{x=0,y=-1,z=0},{x=0,y=0,z=1},{x=0,y=0,z=-1}}
	}}
})
minetest.register_node("vexcazer_extras:collision_mese_off", {
	drawtype="airlike",
	drop="",
	paramtype = "light",
	sunlight_propagates = true,
	pointable=false,
	walkable=false,
	groups = {not_in_creative_inventory=1},
	mesecons = {conductor = {
		state = mesecon.state.on,
		offstate = "vexcazer_extras:collision_mese",
		rules={{x=1,y=0,z=0},{x=-1,y=0,z=0},{x=0,y=1,z=0},{x=0,y=-1,z=0},{x=0,y=0,z=1},{x=0,y=0,z=-1}}
	}}
})
table.insert(vexcazer_extras.nodes,"vexcazer_extras:collision_mese_pointable")
minetest.register_node("vexcazer_extras:collision_mese_pointable", {
	description = "Collision mesecon effected pointable",
	stack_max=1000,
	inventory_image="default_mese_block.png",
	drawtype="airlike",
	drop="",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {not_in_creative_inventory=1},
	mesecons = {conductor = {
		state = mesecon.state.off,
		onstate = "vexcazer_extras:collision_mese_off_pointable",
		rules={{x=1,y=0,z=0},{x=-1,y=0,z=0},{x=0,y=1,z=0},{x=0,y=-1,z=0},{x=0,y=0,z=1},{x=0,y=0,z=-1}}
	}}
})
minetest.register_node("vexcazer_extras:collision_mese_off_pointable", {
	drawtype="airlike",
	drop="",
	paramtype = "light",
	sunlight_propagates = true,
	pointable=false,
	walkable=false,
	groups = {not_in_creative_inventory=1},
	mesecons = {conductor = {
		state = mesecon.state.on,
		offstate = "vexcazer_extras:collision_mese_pointable",
		rules={{x=1,y=0,z=0},{x=-1,y=0,z=0},{x=0,y=1,z=0},{x=0,y=-1,z=0},{x=0,y=0,z=1},{x=0,y=0,z=-1}}
	}}
})

end
table.insert(vexcazer_extras.nodes,"vexcazer_extras:shadow")
minetest.register_node("vexcazer_extras:shadow", {
	description = "Shadow",
	stack_max=1000,
	inventory_image="gui_formbg.png",
	drawtype="airlike",
	drop="",
	walkable=false,
	pointable=false,
	groups = {not_in_creative_inventory=1},
})
table.insert(vexcazer_extras.nodes,"vexcazer_extras:kill")
minetest.register_node("vexcazer_extras:kill", {
	description = "Kill",
	stack_max=1000,
	inventory_image="default_lava.png",
	drawtype="airlike",
	drop="",
	paramtype = "light",
	walkable=false,
	sunlight_propagates = true,
	damage_per_second=100,
	pointable=false,
	groups = {not_in_creative_inventory=1},
})
table.insert(vexcazer_extras.nodes,"vexcazer_extras:damage")
minetest.register_node("vexcazer_extras:damage", {
	description = "Damage",
	stack_max=1000,
	inventory_image="default_lava.png",
	drawtype="airlike",
	drop="",
	paramtype = "light",
	walkable=false,
	sunlight_propagates = true,
	damage_per_second=1,
	pointable=false,
	groups = {not_in_creative_inventory=1},
})

table.insert(vexcazer_extras.nodes,"vexcazer_extras:sourceblocking")
minetest.register_node("vexcazer_extras:sourceblocking", {
	description = "Sourceblocking",
	stack_max=1000,
	drawtype="nodebox",
	node_box={
		type="fixed",
		node_box={0,0,0,0,0,0},
	},
	drop="",
	paramtype = "light",
	--walkable=false,
	sunlight_propagates = true,
	pointable=false,
	groups = {not_in_creative_inventory=1},
})