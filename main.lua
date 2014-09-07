--use a number so you can stop rendering at certain layers, so you can view internal things
--store each block in a new table using x,y,z as sub-tables instead of this mess
--note: up-right is x+ down right is z+ and up is y+
require "helpers"

love.window.setMode( 1600, 900)

math.randomseed( os.time()) 

blocksize = 40
diameter = 10
playerpos = {5,11,5}
map = {}
mapblock = 0

black = {0,0,0}
white = {255,255,255}

peelback_modifier_z = 0 --stop rendering of chunk before value

--super nested
--do this this way for super easy access
for x = 1,diameter do
	if map[x] == nil then
		map[x] = {}
	end
	for y = 1,diameter do
		if map[x][y] == nil then
			map[x][y] = {}
		end
		for z = 1,diameter do	
			map[x][y][z] = {}
			local gen = math.random()
			if y == diameter and gen > 0.7 then
				map[x][y][z]["id"]    = 3--grass
				map[x][y][z]["color"] = {0,200,0}
			elseif y > 5 and y < 10 then
				map[x][y][z]["id"]    = 2--dirt
				map[x][y][z]["color"] = {128,80,29}
			--elseif gen < 0.5 then
			--	map[x][y][z]["id"]    = 0--air
			--	--map[x][y][z]["color"] =	{150,150,150}
			elseif gen >= 0.2 and y < 5 then
				map[x][y][z]["id"]    = 1--stone
				map[x][y][z]["color"] =	{150,150,150}
			else
				map[x][y][z]["id"]    = 0--air
			end
			map[x][y][z]["pos"] = {}
			map[x][y][z]["pos"][x] = x
			map[x][y][z]["pos"][y] = y
			map[x][y][z]["pos"][z] = z
			
		end
	end
end
function love.update()
	--fall placeholder
	if playerpos[2] > 1 then
		if map[playerpos[1]][playerpos[2]-1][playerpos[3]]["id"] == 0 then
			playerpos[2] = playerpos[2] - 1
		end
	end
	--auto jump thing
	if playerpos[2] <= diameter then
		if map[playerpos[1]][playerpos[2]][playerpos[3]]["id"] ~= 0 then
			playerpos[2] = playerpos[2] + 1
		end
	end
end
function love.keypressed(key)
	--move
	if key == 'up' and playerpos[3] > 1 then
		playerpos[3] = playerpos[3] - 1 
	end
	if key == 'down' and playerpos[3] < diameter then
		playerpos[3] = playerpos[3] + 1 
	end
	if key == 'left' and playerpos[1]  > 1 then
		playerpos[1] = playerpos[1] - 1 
	end
	if key == 'right' and playerpos[1] < diameter then
		playerpos[1] = playerpos[1] + 1 
	end
	--mining
	if (playerpos[2] <= diameter and playerpos[2] >= 1) then 
		local x = playerpos[1]
		local y = playerpos[2]
		local z = playerpos[3]
		if key == 'w' and playerpos[3] > 1 then
			map[x][y][z-1]["id"] = 0
		end
		if key == 's' and playerpos[3] < diameter then
			map[x][y][z+1]["id"] = 0
		end
		if key == 'a' and playerpos[1] > 1 then
			map[x-1][y][z]["id"] = 0
		end
		if key == 'd' and playerpos[1] < diameter then
			map[x+1][y][z]["id"] = 0
		end
		if key == 'e' and playerpos[2] < diameter then
			map[x][y+1][z]["id"] = 0
		end
		if key == 'q' and playerpos[2] > 1 then
			map[x][y-1][z]["id"] = 0
		end
	end
end

function love.draw()
	--draw the earth and player
	for x = diameter,1,-1 do
		for y = 1,diameter do
			for z = 1,diameter do
				local pos    = map[x][y][z]["pos"]
				local id     = map[x][y][z]["id"]
				local color  = map[x][y][z]["color"]
				--if air then do nothing
				if ((z <= diameter-peelback_modifier_z) or (z <= diameter-peelback_modifier_z) or (z == diameter-peelback_modifier_z)) and id ~= 0 then
					--eventually have faces render based on player pos

					local x = x * blocksize
					local y = ((y*-1)+diameter*1.5) * blocksize
					local z = z * blocksize
					local x = x + z
					local y = y + z - (x/2)
					
					--BOTTOM FACE
					--left corner
					x1 = x
					y1 = y+((blocksize/2)+blocksize)
					--bottom corner
					x2 = x+(blocksize)
					y2 = y+(blocksize*2)
					--right corner
					x3 = x+(blocksize*2)
					y3 = y+((blocksize/2)+blocksize)
					--top corner
					x4 = x+(blocksize)
					y4 = y+(blocksize)
					love.graphics.setColor( color, alpha )
					love.graphics.polygon('fill', x1,y1,x2,y2,x3,y3,x4,y4)
					love.graphics.setColor( black, alpha )
					love.graphics.polygon('line', x1,y1,x2,y2,x3,y3,x4,y4)
					
					-----LEFT REAR FACE
					--top left
					x5 = x
					y5 = y+(blocksize/2)
					--top right
					x6 = x+(blocksize)
					y6 = y
					--bottom right
					x7 = x+(blocksize)
					y7 = y+(blocksize)
					--bottom left
					x8 = x
					y8 = y+((blocksize/2)+blocksize)
					love.graphics.setColor( color, alpha )
					love.graphics.polygon('fill', x5,y5,x6,y6,x7,y7,x8,y8)
					love.graphics.setColor( black, alpha )
					love.graphics.polygon('line', x5,y5,x6,y6,x7,y7,x8,y8)

					-----RIGHT REAR FACE
					--top left
					x9 = x+(blocksize)
					y9 = y
					--top right
					x10 = x+(blocksize*2)
					y10 = y+(blocksize/2)
					--bottom right
					x11 = x+(blocksize*2)
					y11 = y+((blocksize/2)+blocksize)
					--bottom left
					x12 = x+(blocksize)
					y12 = y+(blocksize)
					love.graphics.setColor( color, alpha )
					love.graphics.polygon('fill', x9,y9,x10,y10,x11,y11,x12,y12)
					love.graphics.setColor( black, alpha )
					love.graphics.polygon('line', x9,y9,x10,y10,x11,y11,x12,y12)	
								
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
					y8 = y+((blocksize/2)+blocksize)
					love.graphics.setColor( color, alpha )
					love.graphics.polygon('fill', x5,y5,x6,y6,x7,y7,x8,y8)
					love.graphics.setColor( black, alpha )
					love.graphics.polygon('line', x5,y5,x6,y6,x7,y7,x8,y8)
					
					-----RIGHT FRONT FACE
					--top left
					x9 = x+(blocksize)
					y9 = y+(blocksize)
					--top right
					x10 = x+(blocksize*2)
					y10 = y+(blocksize/2)
					--bottom right
					x11 = x+(blocksize*2)
					y11 = y + ((blocksize/2)+blocksize)
					--bottom left
					x12 = x+(blocksize)
					y12 = y+(blocksize*2)
					love.graphics.setColor( color, alpha )
					love.graphics.polygon('fill', x9,y9,x10,y10,x11,y11,x12,y12)
					love.graphics.setColor( black, alpha )
					love.graphics.polygon('line', x9,y9,x10,y10,x11,y11,x12,y12)
				
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
					love.graphics.setColor( color, alpha )
					love.graphics.polygon('fill', x1,y1,x2,y2,x3,y3,x4,y4)
					love.graphics.setColor( black, alpha )
					love.graphics.polygon('line', x1,y1,x2,y2,x3,y3,x4,y4)
					
					--debug info
					--love.graphics.print(table.tostring(pos), x+15, y+15)
					--love.graphics.print(table.tostring(pos), x+40, y+30)
				--draw the player on top of block
				end
				love.graphics.setColor( white, alpha )
				if playerpos[1] == pos[x] and playerpos[2] == pos[y] + 1 and playerpos[3] == pos[z] then
					local x = x * blocksize
					local y = ((y*-1)+diameter*1.5) * blocksize
					local z = (z * (blocksize))+(blocksize)
					local x = x + z
					local y = y + z - (x/2)
					love.graphics.circle( "fill", x, y, 15, 100 )
				end
			end
		end
	end
end
