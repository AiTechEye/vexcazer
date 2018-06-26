vexcazer_con={jobs={},user={},max_admin=3000,max_mod=495,max_default=99,max_dis_admin=6,max_dis_mod=3,max_dis_default=2}

vexcazer_con.counter=function(a)
	local b=0
	for i, a in pairs(a) do
		b=b+1
	end
	return b
end

vexcazer_con.run=function()
	for i, a in pairs(vexcazer_con.user) do

		if not (a.name and a.count>1 and vexcazer_con.counter(a.jobs)>0) then
			vexcazer_con.user[a.name]=nil
			vexcazer_con.run()
			return
		end

		for xyz, pos in pairs(a.jobs) do
			if os.clock()-a.time>5 then
				minetest.chat_send_player(a.name, "<Vexcazer> using aborted, took more then 5 sec (" .. (os.clock()-a.time) ..")")
				vexcazer_con.user[a.name]=nil
				vexcazer_con.run()
				return
			end
			vexcazer.dig(pos,a.input,a.nolazer)
			if a.place then
				vexcazer.place({pos=pos,node=a.place},a.input)
			end
			vexcazer_con.user[a.name].count=vexcazer_con.user[a.name].count-1
			if vexcazer_con.user[a.name].count<1 then 
				vexcazer_con.user[a.name]=nil
				vexcazer_con.run()
				return
			end
			for x=-a.dis,a.dis,1 do
			for y=-a.dis,a.dis,1 do
			for z=-a.dis,a.dis,1 do
				local n={x=pos.x+x,y=pos.y+y,z=pos.z+z}
				if minetest.get_node(n).name==a.node then
					vexcazer_con.user[a.name].jobs[n.x .. "." .. n.y .."." ..n.z]=n
				end
			end
			end
			end
			vexcazer_con.user[a.name].jobs[xyz]=nil
		end
		if vexcazer_con.counter(vexcazer_con.user[a.name].jobs)<1 then 
			vexcazer_con.user[a.name]=nil
			vexcazer_con.run()
			return
		end
	end
	if vexcazer_con.counter(vexcazer_con.user)>0 then

	minetest.after((0.1), function()
		vexcazer_con.run()
		return
	end)
	end
end

vexcazer.registry_mode({
	name="Con",
	info="Dig/Replace blocks that are connected to each other\nUSE to replace with stack to left,\n PLACE to dig\nstack count to right is spacing / max space between the blocks\nHold JUMP to use obove position\nUSE/PLACE again to abort",
	info_default="Max dig: " .. vexcazer_con.max_default .."\nMax spacing: " .. (vexcazer_con.max_dis_default-1),
	info_mod="Max dig: " .. vexcazer_con.max_mod .."\nMax spacing: " .. (vexcazer_con.max_dis_mod-1),
	info_admin="Max dig: " .. vexcazer_con.max_admin .."\nMax spacing: " .. (vexcazer_con.max_dis_admin-1),

	wear_on_use=3,
	wear_on_place=5,
	disallow_damage_on_use=true,
	on_place=function(itemstack, user, pointed_thing,input)
		if pointed_thing.type~="node" then return itemstack end
		local count=user:get_inventory():get_stack("main", input.index-1):get_count()
		local dis=user:get_inventory():get_stack("main", input.index+1):get_count()
		if count==0 then
			count=9
		elseif count>input.max_amount then
			if input.admin then 
				count=vexcazer_con.max_admin
			elseif input.mod then
				count=vexcazer_con.max_mod
			else
				count=vexcazer_con.max_default
			end
		end
		dis=dis+1
		--if dis==0 then
		--	dis=1
		--else
		if input.admin and dis>vexcazer_con.max_dis_admin then 
			dis=vexcazer_con.max_dis_admin
		elseif input.mod and dis>vexcazer_con.max_dis_mod then
			dis=vexcazer_con.max_dis_mod
		elseif input.default and dis>vexcazer_con.max_dis_default then
			dis=vexcazer_con.max_dis_default
		end


		local pos=pointed_thing.under
		if user:get_player_control().jump then
			pos=pointed_thing.above
		end

		if minetest.get_node(pos).name=="air" then return end

		local upos=user:get_pos()
		local node=minetest.get_node(pos).name
		local name=user:get_player_name()

		if vexcazer_con.user[name] then
			vexcazer_con.user[name].count=0
			return
		end

		vexcazer_con.user[name]={time=os.clock(),node=node,input=input,count=count,dis=dis,name=name,jobs={}}
		vexcazer_con.user[name].jobs[pos.x .."." .. pos.y .."." ..pos.z]=pos
		vexcazer_con.run()
		return itemstack
	end,

	on_use = function(itemstack, user, pointed_thing,input)
		if pointed_thing.type~="node" then return itemstack end
		local count=user:get_inventory():get_stack("main", input.index-1):get_count()
		local item=user:get_inventory():get_stack("main", input.index-1):get_name()
		local dis=user:get_inventory():get_stack("main", input.index+1):get_count()

		if not minetest.registered_nodes[item] then
			item=input.lazer
		end

		if count==0 then
			count=9
		elseif count>input.max_amount then
			if input.admin then 
				count=vexcazer_con.max_admin
			elseif input.mod then
				count=vexcazer_con.max_mod
			else
				count=vexcazer_con.max_default
			end
		end
		dis=dis+1
		--if dis==0 then
		--	dis=1
		--else
		if input.admin and dis>vexcazer_con.max_dis_admin then 
			dis=vexcazer_con.max_dis_admin
		elseif input.mod and dis>vexcazer_con.max_dis_mod then
			dis=vexcazer_con.max_dis_mod
		elseif input.default and dis>vexcazer_con.max_dis_default then
			dis=vexcazer_con.max_dis_default
		end

		local pos=pointed_thing.under
		if user:get_player_control().jump then
			pos=pointed_thing.above
		end
		local upos=user:get_pos()
		local node=minetest.get_node(pos).name
		local name=user:get_player_name()

		if vexcazer_con.user[name] then
			vexcazer_con.user[name].count=0
			return
		end
		vexcazer_con.user[name]={time=os.clock(),node=node,input=input,count=count,dis=dis,name=name,place={name=item},nolazer=true,jobs={}}
		vexcazer_con.user[name].jobs[pos.x .."." .. pos.y .."." ..pos.z]=pos
		vexcazer_con.run()
		return itemstack
	end
})