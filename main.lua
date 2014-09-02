--[[
goals for this project
1.) 3d isometric environment which the player can move around in
2.) collision detect using blocks, not physics
3.) moveable camera, using same technique as rct
4.) experiment with moving cameras around on center of axises as well, instead of just corners
]]--

require "helpers"

blocksize = 40
diameter = 5

map = {}
mapblock = 0
for x = 1,diameter do
	for y = 1,diameter do
		for z = 1,diameter do
			map[mapblock]       = {}
			map[mapblock]["id"] = mapblock
			map[mapblock]["x"]  = x
			map[mapblock]["y"]  = y
			map[mapblock]["z"]  = z
			mapblock            = mapblock + 1
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
				
				
				if x == 1 or y == 1 or z == diameter then
					
					local x = x * blocksize
					local y = y * blocksize
					local z = z * blocksize
					
					local x = x + z
					local y = y + z
					
					love.graphics.print(id, x, y)
					
				end
			end
		end
	end
end
