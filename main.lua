--use a number so you can stop rendering at certain layers, so you can view internal things
--store each block in a new table using x,y,z as sub-tables instead of this mess
require "helpers"

math.randomseed( os.time()) 

blocksize = 20
diameter = 5

map = {}
mapblock = 0

peelback_modifier_z = 4 --stop rendering of chunk before value

for x = 1,diameter do
	for y = 1,diameter do
		for z = 1,diameter do
			map[mapblock]       = {}
			if y < 1 then
				map[mapblock]["id"] = 1 --stone
			elseif math.floor(math.random()*100 + 0.5) < 10 then
				map[mapblock]["id"] = 2 -- gem
			else
				map[mapblock]["id"] = 0 -- air
			end
			map[mapblock]["x"]      = x
			map[mapblock]["y"]      = y
			map[mapblock]["z"]      = z
			map[mapblock]["color"]  = {math.random(0,255),math.random(0,255),math.random(0,255)}
			mapblock                = mapblock + 1
		end
	end
end


function love.keypressed(key)
	if key == 'up' then
		blocksize = blocksize + 1
	elseif key == 'down' then
		if blocksize > 0 then
			blocksize = blocksize - 1
		end
	end
	if key == 'left' then
		if peelback_modifier_z < diameter-1 then
			peelback_modifier_z = peelback_modifier_z + 1
		end
	elseif key == 'right' then
		if peelback_modifier_z > 0 then
			peelback_modifier_z = peelback_modifier_z - 1
		end
	end
end

function love.draw()
	local tempmapblock = 0
	for x = 1,diameter do
		for y = 1,diameter do
			for z = 1,diameter do
				local id     = map[tempmapblock]["id"]
				local x      = map[tempmapblock]["x"]
				local y      = map[tempmapblock]["y"]
				local z      = map[tempmapblock]["z"]
				local color  = map[tempmapblock]["color"]
				if (x == 1 and z <= diameter-peelback_modifier_z) or (y == 1 and z <= diameter-peelback_modifier_z) or (z == diameter-peelback_modifier_z) and id ~= 0 then
					--[[
					local x = x * blocksize
					local y = (y+7) * blocksize
					local z = z * blocksize
					local x = x + z
					local y = y + z - (x/2)
					love.graphics.print(id, x, y)
					]]--
					local x = x * blocksize
					local y = (y+3) * blocksize
					local z = z * blocksize
					local x = x + z
					local y = y + z - (x/2)
					love.graphics.setColor( color, alpha )
					--TOP FACE
					--left corner
					x1 = x
					y1 = y+(blocksize/2)--10
					--bottom corner
					x2 = x+blocksize--20
					y2 = y+blocksize--20
					--right corner
					x3 = x+(blocksize*2)--40
					y3 = y+(blocksize/2)--10
					--top corner
					x4 = x+blocksize--20
					y4 = y
					
					love.graphics.polygon('line', x1,y1,x2,y2,x3,y3,x4,y4)
					-----LEFT FRONT FACE
					--top left
					x5 = x
					y5 = y+(blocksize/2)
					--top right
					x6 = x+(blocksize)
					y6 = y+(blocksize)
					--bottom right
					x7 = x+(blocksize)
					y7 = y+(blocksize*2)
					--bottom left
					x8 = x
					--20+(20/2)
					y8 = y + ((blocksize/2)+blocksize)
					love.graphics.polygon('line', x5,y5,x6,y6,x7,y7,x8,y8)					
				end
				tempmapblock = tempmapblock + 1	
			end
		end
	end
end
