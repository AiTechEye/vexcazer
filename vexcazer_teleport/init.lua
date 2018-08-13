vexcazer.teleport={}

-- powersaving mode in 3 steps
--checks 10 times/s 5< away
--checks 1 times/s 10< away
--checks 1 time each 2'th s >10 away
--slow down if something keep same distance it in 20s

minetest.register_chatcommand("dropme", {
	params = "",
	description = "Drop yourself from teleporting",
	func = function(name, param)
	for i, tp in pairs(vexcazer.teleport) do
		if tp.target:is_player() and tp.target:get_player_name()==name then
			minetest.chat_send_player(tp.user, "<vexcazer> Your teleport target is droped")
			vexcazer.teleport[tp.user]=nil
			minetest.chat_send_player(name, "<vexcazer> You is now droped")
			return true
		end
	end
	minetest.chat_send_player(name, "This command is only used when someone keep teleporting you")
end})


minetest.register_on_leaveplayer(function(player)
	local name=player:get_player_name()
	if vexcazer.teleport[name]~=nil then vexcazer.teleport[name]=nil end
end)

local teleport=function(itemstack, user, pointed_thing,input,object)
		local pos={}
		if object and not vexcazer.teleport[input.user_name] then
			return
		end
		if pointed_thing.type=="node" then
			pos=pointed_thing.under
		else
			return itemstack
		end
		local tp2node1=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y+1, z=pos.z}).name]
		local tp2node2=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y+2, z=pos.z}).name]
		if (tp2node1.walkable==false and tp2node2.walkable==false)  then
			if input.default and user:get_pos().y<=pos.y then
				local walkable=0
				local tp2node1=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y, z=pos.z}).name].walkable==false
				local tp2node2=minetest.registered_nodes[minetest.get_node({ x=pos.x+1, y=pos.y, z=pos.z}).name].walkable==false
				local tp2node3=minetest.registered_nodes[minetest.get_node({ x=pos.x-1, y=pos.y, z=pos.z}).name].walkable==false
				local tp2node4=minetest.registered_nodes[minetest.get_node({ x=pos.x+1, y=pos.y, z=pos.z+1}).name].walkable==false
				local tp2node5=minetest.registered_nodes[minetest.get_node({ x=pos.x-1, y=pos.y, z=pos.z-1}).name].walkable==false
				local tp2node6=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y, z=pos.z+1}).name].walkable==false
				local tp2node7=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y, z=pos.z-1}).name].walkable==false
				local tp2node8=minetest.registered_nodes[minetest.get_node({ x=pos.x+1, y=pos.y, z=pos.z-1}).name].walkable==false
				local tp2node9=minetest.registered_nodes[minetest.get_node({ x=pos.x-1, y=pos.y, z=pos.z+1} ).name].walkable==false
				if tp2node1 then walkable=1 end
				if tp2node2 then walkable=1 end
				if tp2node3 then walkable=1 end
				if tp2node4 then walkable=1 end
				if tp2node5 then walkable=1 end
				if tp2node6 then walkable=1 end
				if tp2node7 then walkable=1 end
				if tp2node8 then walkable=1 end
				if tp2node9 then walkable=1 end
				if walkable==0 then return false end
			end

			if object and vexcazer.teleport[input.user_name] then
				local ob=vexcazer.teleport[input.user_name].target
				if ob:get_luaentity()==nil and ob:is_player()==false then
					vexcazer.teleport[input.user_name]=nil
					return itemstack
				end
				if ob:is_player()==false then pos.y=pos.y+1 end
				user=ob
			end

			user:move_to({ x=pos.x, y=pos.y+1, z=pos.z },false)
			minetest.sound_play("vexcazer_teleport", {pos = user:get_pos(), gain = 1.0, max_hear_distance = 10,})
		else
			if object and vexcazer.teleport[input.user_name] then
				user=vexcazer.teleport[input.user_name].target
				if user:is_player()==false then pointed_thing.above.y=pointed_thing.above.y+1 end
			end
			user:move_to(pointed_thing.above,false)
			minetest.sound_play("vexcazer_teleport", {pos = user:get_pos(), gain = 1.0, max_hear_distance = 10,})
		end
end


vexcazer.registry_mode({
	wear_on_use=1,
	wear_on_place=1,
	name="Teleport",
	info="USE on a object to select, use on a block to teleport it\nPLACE on a block to teleport yourself",
	disallow_damage_on_use=true,
	on_place=function(itemstack, user, pointed_thing,input)
		teleport(itemstack, user, pointed_thing,input)
	end,
	on_use=function(itemstack, user, pointed_thing,input)
		if pointed_thing.type=="object" then
			vexcazer.teleport[input.user_name]={target=pointed_thing.ref,user=user:get_player_name()}
			if pointed_thing.ref:is_player() then
				minetest.chat_send_player(pointed_thing.ref:get_player_name(), "<vexcazer> You are selected to be teleported, type /dropme to be free")
			end
		elseif pointed_thing.type=="node" then
			teleport(itemstack, user, pointed_thing,input,true)
		end
	end
})
