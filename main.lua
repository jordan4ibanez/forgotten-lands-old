#use a number so you can stop rendering at certain layers, so you can view internal things

require "helpers"

math.randomseed( os.time()) 

blocksize = 40
diameter = 5

map = {}
mapblock = 0

peelback_modifier_z = 0 --stop rendering of chunk before value

for x = 1,diameter do
	for y = 1,diameter do
		for z = 1,diameter do
			map[mapblock]       = {}
			if y == 1 then
				map[mapblock]["id"] = "1" --stone
			elseif math.floor(math.random()*100 + 0.5) < 10 then
				map[mapblock]["id"] = "2" -- gem
			else
				map[mapblock]["id"] = "0" -- dirt
			end
			map[mapblock]["x"]  = x
			map[mapblock]["y"]  = y
			map[mapblock]["z"]  = z
			mapblock            = mapblock + 1
		end
	end
end


function love.keypressed(key)
	if key == 'up' then
		if peelback_modifier_z < diameter then
			peelback_modifier_z = peelback_modifier_z + 1
		end
	elseif key == 'down' then
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
				tempmapblock = tempmapblock + 1				
				if (x == 1 and z <= diameter-peelback_modifier_z) or (y == 1 and z <= diameter-peelback_modifier_z) or (z == diameter-peelback_modifier_z) then
					local x = x * blocksize
					local y = y * blocksize
					local z = z * blocksize
					local x = x + (z/2)
					local y = y + (z/2)
					love.graphics.print(id, x, y)
				end
			end
		end
	end
end
