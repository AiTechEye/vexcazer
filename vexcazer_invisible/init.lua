invisible={time=0,armor=minetest.get_modpath("3d_armor")}

vexcazer.registry_mode({
	name="Invisible",
	info="USE to active/inactive",
	hide_mode_default=true,
	disallow_damage_on_use=true,
	wear_on_use=0,
	on_use=function(itemstack, user, pointed_thing,input)
		local name=user:get_player_name()
		if not invisible[name] then
			user:set_nametag_attributes({color = {a = 0, r = 255, g = 255, b = 255}})
			invisible[name]={}
			invisible[name].tool=sneak
			invisible[name].collisionbox=user:get_properties().collisionbox
			invisible[name].visual_size=user:get_properties().visual_size
			invisible[name].textures=user:get_properties().textures
			user:set_properties({
				visual = "mesh",
				textures={"vexcazer_invisible.png"},
				visual_size = {x=0, y=0},
				collisionbox = {-0.1,0,-0.1,0.1,0,0.1},
			})
			minetest.chat_send_player(name, "invisible on")			
		else
			user:set_nametag_attributes({color = {a = 255, r = 255, g = 255, b = 255}})
			user:set_properties({
				visual = "mesh",
				textures=invisible[name].textures,
				visual_size = invisible[name].visual_size,
				collisionbox=invisible[name].collisionbox
			})
			invisible[name]=nil
			if invisible.armor then
				armor:set_player_armor(user)
				armor:update_inventory(user)
			end
			minetest.chat_send_player(name, "invisible off")
		end
	end
})

