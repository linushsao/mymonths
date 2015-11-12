
--Sets the weather types for each month
local t = 0
minetest.register_globalstep(function(dtime)
local month = mymonths.month_counter
	t = t + dtime
	if t < 5 then
		return
	end
	t = 0

   	if 	mymonths.weather == "rain" or 
		mymonths.weather == "storm" or 
		mymonths.weather == "snow" or 
		mymonths.weather == "snowstorm" then
		if math.random(1, 50) == 1 then
			mymonths.weather = "none"
		end
	else

		if month == "1" then--January
				if math.random(1, 100) == 1 then
				mymonths.weather = "snow"
				elseif math.random(1, 500) == 1 then
				mymonths.weather = "snowstorm"
				end
		elseif month == "2" then--Febuary
				if math.random(1, 100) == 1 then
				mymonths.weather = "snow"
				elseif math.random(1, 500) == 1 then
				mymonths.weather = "snowstorm"
				end
		elseif month == "3" then --March
				if math.random(1, 100) == 1 then
				mymonths.weather = "rain"
				elseif math.random(1, 250) == 2 then
				mymonths.weather = "snow"
				end
		elseif month == "4" then --April
				if math.random(1, 100) == 1 then
				mymonths.weather = "rain"
				end
		elseif month == "5" then --May
				if math.random(1, 150) == 1 then
				mymonths.weather = "rain"
				elseif math.random(1, 500) == 1 then
				mymonths.weather = "storm"
				end
		elseif month == "6" then --June
				if math.random(1, 200) == 1 then
				mymonths.weather = "rain"
				elseif math.random(1, 500) == 1 then
				mymonths.weather = "storm"
				end
		elseif month == "7" then --July
				if math.random(1, 500) == 1 then
				mymonths.weather = "rain"
				elseif math.random(1, 500) == 1 then
				mymonths.weather = "storm"
				end
		elseif month == "8" then --Augest
				if math.random(1, 500) == 1 then
				mymonths.weather = "rain"
				elseif math.random(1, 500) == 1 then
				mymonths.weather = "storm"
				end
		elseif month == "9" then --September
				if math.random(1, 150) == 1 then
				mymonths.weather = "rain"
				elseif math.random(1, 250) == 1 then
				mymonths.weather = "storm"
				end
		elseif month == "10" then --October
				if math.random(1, 100) == 1 then
				mymonths.weather = "rain"
				elseif math.random(1, 250) == 1 then
				mymonths.weather = "storm"
				end
		elseif month == "11" then --November
				if math.random(1, 100) == 1 then
				mymonths.weather = "rain"
				elseif math.random(1, 200) == 2 then
				mymonths.weather = "snow"
				end
		elseif month == "12" then --December
				if math.random(1, 250) == 1 then
				mymonths.weather = "rain"
				elseif math.random(1, 100) == 1 then
				mymonths.weather = "snow"
				end
		end

	end
end)

--Weather vectors and particles are from jeija's weather mod
addvectors = function (v1, v2)
	return {x=v1.x+v2.x, y=v1.y+v2.y, z=v1.z+v2.z}
end

local t = 0
minetest.register_globalstep(function(dtime)

	mymonths.weather2 = mymonths.weather
	for _, player in ipairs(minetest.get_connected_players()) do
		local ppos = player:getpos()
		local name = player:get_player_name()
		local nodein = minetest.get_node(ppos)
		local nodeu = minetest.get_node({x=ppos.x,y=ppos.y-1,z=ppos.z})
		
		local biome_jungle = minetest.find_node_near(ppos, 5, "default:jungletree","default:junglegrass")
		local biome_desert = minetest.find_node_near(ppos, 5, "default:desert_sand","default:desert_stone")
		local biome_snow = minetest.find_node_near(ppos, 5, "default:snow","default:snowblock","default:dirt_with_snow","default:ice")
		
		local minp = addvectors(ppos, {x=-10, y=7, z=-10})
		local maxp = addvectors(ppos, {x= 10, y=7, z= 10})
		local minp_deep = addvectors(ppos, {x=-10, y=3.2, z=-10})
		local maxp_deep = addvectors(ppos, {x= 10, y=2.6, z= 10})
		local vel_rain = {x=0, y=-4, z=0}
		local acc_rain = {x=0, y=-9.81, z=0}
		local vel_snow = {x=0, y=-0.4, z=0}
		local acc_snow = {x=0, y=-0.5, z=0}
		local ran_s = math.random(1,6)
		
		--slows players walk in snow
		if nodein.name == "mymonths:snow_cover_1" then
			player:set_physics_override(0.95,1,1,true,false)
		elseif nodein.name == "mymonths:snow_cover_2" then
			player:set_physics_override(0.8,1,1,true,false)
		elseif nodein.name == "mymonths:snow_cover_3" then
			player:set_physics_override(0.65,1,1,true,false)
		elseif nodein.name == "mymonths:snow_cover_4" then
			player:set_physics_override(0.5,1,1,true,false)
		elseif nodein.name == "mymonths:snow_cover_5" then
			player:set_physics_override(0.35,1,1,true,false)
		else
			player:set_physics_override(1,1,1,true,false)
		end

		--check light to make sure player is outside
		if minetest.get_node_light({x=ppos.x,y=ppos.y+1,z=ppos.z}, 0.5) ~= 15 then return end	
		--checks if there is any weather
		if mymonths.weather2 == "none" then return end

		--changes weather based on biome
		--Jungle
		if biome_jungle ~= nil then
			if 		mymonths.weather == "snow" then
					mymonths.weather2 = "rain"
			elseif 	mymonths.weather == "snowstorm" then
					mymonths.weather2 = "storm"
			end
		elseif biome_desert ~= nil then
			if		mymonths.weather == "snow" or
					mymonths.weather == "snowstorm" or
					mymonths.weather == "storm" or
					mymonths.weather == "rain" then
					mymonths.weather2 = "none"
			end
		elseif biome_snow ~= nil then
			if		mymonths.weather == "rain" then
					mymonths.weather2 = "snow"
			elseif 	mymonths.weather == "storm" then
					mymonths.weather2 = "snowstorm"
			end
		else
			mymonths.weather2 = mymonths.weather
		end
	
	if mymonths.weather2 == "storm" then
		local ran_t = math.random(1,200)
			minetest.add_particlespawner({amount = 40, time = 0.5,
				minpos = minp, maxpos=maxp,
				minvel = vel_rain, maxvel = vel_rain,
				minacc = acc_rain, maxacc = acc_rain,
				minexptime = 0.8, maxexptime = 0.8,
				minsize = 25, maxsize = 40,
				collisiondetection = false, 
				vertical = true, 
				texture = "weather_rain_dark.png", 
				playername = name})

				if ran_t == 1 then
					minetest.sound_play("mymonths_thunder", {
					pos = ppos,
					max_hear_distance = 10,
					gain = 10.0,
					})
				end
	elseif mymonths.weather2 == "rain" then
		minetest.add_particlespawner({amount = 15, time = 0.5,
			minpos = minp, maxpos = maxp,
			minvel = vel_rain, maxvel = vel_rain,
			minacc = acc_rain, maxacc = acc_rain,
			minexptime = 0.6, maxexptime = 0.8,
			minsize = 25, maxsize = 25,
			collisiondetection = false,
			vertical = true, 
			texture = "weather_rain.png", 
			playername = name})
	elseif mymonths.weather2 == "snow" then
		minetest.add_particlespawner({amount = 4, time = 0.5,
			minpos = minp, maxpos = maxp,
			minvel = vel_snow, maxvel = vel_snow,
			minacc = acc_snow, maxacc = acc_snow,
			minexptime = 4, maxexptime = 8,
			minsize = 15, maxsize = 25,
			collisiondetection = false, 
			vertical = true, 
			texture = "weather_snow.png", 
			playername = name})

		minetest.add_particlespawner({amount = 4, time = 0.5,
			minpos = minp_deep, maxpos = maxp_deep,
			minvel = vel_snow, maxvel = vel_snow,
			minacc = acc_snow, maxacc = acc_snow,
			minexptime = 4, maxexptime = 6,
			minesize = 15, maxsize = 25,
			collisiondetection = false, 
			vertical = true, 
			texture = "weather_snow.png", 
			playername = name})

	elseif mymonths.weather2 == "snowstorm" then
		minetest.add_particlespawner({amount = 25, time = 0.5,
			minpos = minp, maxpos = maxp,
			minvel = vel_snow, maxvel = vel_snow,
			minacc = acc_snow, maxacc = acc_snow,
			minexptime = 4, maxexptime = 6,
			minesize = 15, maxsize = 35,
			collisiondetection = false, 
			vertical = true, 
			texture = "weather_snow.png", 
			playername = name})
			
		minetest.add_particlespawner({amount = 25, time = 0.5,
			minpos = minp_deep, maxpos = maxp_deep,
			minvel = vel_snow, maxvel = vel_snow,
			minacc = acc_snow, maxacc = acc_snow,
			minexptime = 4, maxexptime = 6,
			minesize = 15, maxsize = 25,
			collisiondetection = false, 
			vertical = true, 
			texture = "weather_snow.png", 
			playername = name})
	end

	biome_jungle = nil
	biome_snow = nil
	biome_desert = nil
	end
end)
t2 = 0
minetest.register_globalstep(function(dtime)

	t2 = t2 + dtime
	if t2 >= 1 and
	mymonths.weather2 == "rain" then
	t2=0
		minetest.sound_play("mymonths_rain1", {
			pos = ppos,
			max_hear_distance = 10,
			gain = 2.0,
		})
	end
end)

--Puddle node
local puddle_box =
{type  = "fixed",
	fixed = {{-0.1875, -0.5, -0.375, 0.125, -0.4875, 0.3125},
			{-0.25, -0.5, -0.3125, 0.3125, -0.4925, 0.25},
			{-0.3125, -0.5, -0.1875, 0.375, -0.4975, 0.1875},}}
			
minetest.register_node("mymonths:puddle", {
	tiles = {"weather_puddle.png"},
	drawtype = "nodebox",
	paramtype = "light",
	pointable = false,
	buildable_to = true,
	alpha = 50,
	node_box = puddle_box,
	selection_box = puddle_box,
	groups = {not_in_creative_inventory = 1, crumbly = 3, attached_node = 0, falling_node = 1},
	drop = "",
})

--Snow Nodes
local snow = {
	{"mymonths:snow_cover_1","1",-0.4},
	{"mymonths:snow_cover_2","2",-0.2},
	{"mymonths:snow_cover_3","3",0},
	{"mymonths:snow_cover_4","4",0.2},
	{"mymonths:snow_cover_5","5",0.5},
	}
for i in ipairs(snow) do
local itm = snow[i][1]
local num = snow[i][2]
local box = snow[i][3]
minetest.register_node(itm, {
	tiles = {"weather_snow_cover.png"},
	drawtype = "nodebox",
	paramtype = "light",
	buildable_to = true,
	walkable = false,
	node_box = {type  = "fixed",fixed = {-0.5, -0.5, -0.5, 0.5, box, 0.5}},
	selection_box = {type  = "fixed",fixed = {-0.5, -0.5, -0.5, 0.5, box, 0.5}},
	groups = {not_in_creative_inventory = 0, crumbly = 3, attached_node = 0, falling_node = 1},
	drop = "default:snow "..num,
})
end











