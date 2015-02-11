minetest.register_on_punchnode(
	function(pos, node, puncher)
		if node.name == "rainbow:rainbow" then
			local manip = minetest.get_voxel_manip()

			local xMult = 0
			local zMult = 0

			local yaw = puncher:get_look_yaw()
			if yaw ~= nil then
				-- Find angle player facing to enable rotation of position arrow based on yaw.
				yaw = math.deg(yaw)
				yaw = math.fmod (yaw, 360)
--			print('yaw')
--			print( yaw )
				if yaw<0 then yaw = 360 + yaw end
				if yaw>360 then yaw = yaw - 360 end           
				if yaw>315 or yaw<=45 then
					xMult = 1
				elseif yaw>45 and yaw<=135 then
					zMult = 1
				elseif yaw>135 and yaw<=225 then
					xMult = -1
				elseif yaw>225 and yaw<=315 then
					zMult = -1
				end
			end
--			print( xMult)
--			print(zMult)


			minetest.chat_send_all("Rainbow!!")
			print("Rainbow!!")
			local targetWidth = 200
			local diameter = targetWidth/0.8
			local saggita = diameter/2 + ( (diameter/2)^2 - (targetWidth/2)^2 ) ^ 0.5
			local yoffset = saggita*math.cos(math.asin(targetWidth/diameter))
			for dx=-targetWidth,targetWidth do
				local propDistance = dx/diameter
				local asinX = math.asin(propDistance)
				local dy = math.cos(asinX)
--				print (math.floor(pos.y+saggita*dy-yoffset))
				local horizDist = dx+targetWidth
				
				local p = {x=pos.x+horizDist*xMult, y=math.floor(pos.y+saggita*dy-yoffset), z=pos.z+horizDist*zMult}
				manip:read_from_map(p, p)

				local n = minetest.env:get_node(p).name
				if (n == "air") then
--					if firstOK == 0 then firstOK = {x=pos.x+horizDist*xMult, y=math.floor(pos.y+saggita*dy-yoffset), z=pos.z+horizDist*zMult} end
--					lastOK = {x=pos.x+horizDist*xMult, y=math.floor(pos.y+saggita*dy-yoffset), z=pos.z+horizDist*zMult}
					minetest.env:add_node(p, {name="rainbow:rainbow"})
				end
			end
--			minetest.env:add_node(firstOK, {name="rainbow:nyancat"})
--			minetest.env:add_node(lastOK, {name="rainbow:nyancat"})
		end
	end
)



minetest.register_node("rainbow:rainbow", {
	description="Rainbow",
	tiles = {"rainbow.png"},
	drawtype = "nodebox",
	paramtype = "light",
	inventory_image = "rainbow.png",

})

--minetest.register_node("rainbow:nyancathead", {
--	tiles = {"default_nc_side.png", "default_nc_side.png", "default_nc_side.png",
--		"default_nc_side.png", "default_nc_back.png", "default_nc_front.png"},
--})

--minetest.register_node("rainbow:nyancat_rainbow", {
--	description = "Nyan Cat Rainbow",
--	tiles = {"default_nc_rb.png^[transformR90", "default_nc_rb.png^[transformR90",
--		"default_nc_rb.png", "default_nc_rb.png"},
--	paramtype2 = "facedir",
--	groups = {cracky=2},
--	is_ground_content = false,
--})

minetest.register_abm({
	nodenames = {"rainbow:rainbow"},
	interval = 1.0,
	chance = 60,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.env:remove_node(pos)
	end,
})

