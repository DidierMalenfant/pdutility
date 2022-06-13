--
-- graphics - Handy utility functions for Playdate development.
--

local pd <const> = playdate
local gfx <const> = pd.graphics

-- Draw an image tiled within bounds with an optional offset
-- Originally by Dustin Mierau.
function drawTiledImage(img, bounds, offset_x, offset_y)
	offset_x = offset_x or 0
	offset_y = offset_y or 0

	-- Take easy route when no offset is specified.
	if offset_x == 0 and offset_y == 0 then
		img:drawTiled(bounds)
		return
	end

	local iw, ih = img:getSize()
	local sx = math.abs(offset_x % iw) - iw + bounds.x
	local sy = math.abs(offset_y % ih) - ih + bounds.y
	
	local cx, cy, cw, ch = gfx.getClipRect()
	gfx.setClipRect(bounds)
	img:drawTiled(sx, sy, bounds.width - sx, bounds.height - sy)
	gfx.setClipRect(cx, cy, cw, ch)
end

-- Robert Curry
class("Parallax").extends(gfx.sprite)

function Parallax:init()
	Parallax.super.init(self)
	self.layers = {}
end

function Parallax:draw(...)
	gfx.setClipRect(...)
	for _, layer in ipairs(self.layers) do
		local img = layer.image
		-- lock offset to steps of 2 to reduce flashing
		local offset = layer.offset - (layer.offset % 2)
		local w = layer.width
		img:draw(self.x+offset, self.y)
		if offset < 0 or offset > w - self.width then
			if offset > 0 then
				img:draw(self.x+offset-w, self.y)
			else
				img:draw(self.x+offset+w, self.y)
			end
		end
	end
	gfx.clearClipRect()
end

function Parallax:addLayer(img, depth)
	local w, _ = img:getSize()
	local layer = {}
	layer.image = img
	layer.depth = depth
	layer.offset = 0
	layer.width = w
	table.push(self.layers, layer)
end

function Parallax:scroll(delta)
	for _, layer in ipairs(self.layers) do
		layer.offset = math.ring(layer.offset + (delta * layer.depth), -layer.width, 0)
	end
	self:markDirty()
end

-- jaames
-- bezier curve drawing functions for playdate lua
-- these are based on de Casteljau's algorithm
-- this site has a nice interactive demo to compare both types of curve: https://pomax.github.io/bezierinfo/#flattening

-- draws a curve starting at x1,y1, ending at x3,y3, with x2,y2 being a control point that "pulls" the curve towards it
-- steps is the number of line segments to use, lower is better for performance, higher makes your curve look smoother
-- the playdate is kinda slow, so it's recommended to find a relatively low step number that looks passable enough!
function drawQuadraticBezier(x1, y1, x2, y2, x3, y3, steps)
  steps = steps or 8
  local d = 1 / steps
  local prevX = x1
  local prevY = y1
  local x, y
  for t = d, 1, d do
	x = (1 - t) ^ 2 * x1 + 2 * (1 - t) * t * x2 + t ^ 2 * x3
	y = (1 - t) ^ 2 * y1 + 2 * (1 - t) * t * y2 + t ^ 2 * y3
	playdate.graphics.drawLine(prevX, prevY, x, y)
	prevX = x
	prevY = y
  end
end

-- draws a curve starting at x1,y1, ending at x4,y4, with x2,y2 and x3,y3 being a control point that "pulls" the curve towards them
-- (nb: this is the kind of curve you make using the pen tool in vector drawing apps like Adobe Illustator!)
-- steps is the number of line segments to use, lower is better for performance, higher makes your curve look smoother
-- the playdate is kinda slow, so it's recommended to find a relatively low step number that looks passable enough!
function drawCubicBezier(x1, y1, x2, y2, x3, y3, x4, y4, steps)
  steps = steps or 12
  local d = 1 / steps
  local prevX = x1
  local prevY = y1
  local x, y
  for t = d, 1, d do
	x = (1 - t) ^ 3 * x1 + 3 * (1 - t) ^ 2 * t * x2 + 3 * (1 - t) * t ^ 2 * x3 + t ^ 3 * x4
	y = (1 - t) ^ 3 * y1 + 3 * (1 - t) ^ 2 * t * y2 + 3 * (1 - t) * t ^ 2 * y3 + t ^ 3 * y4
	playdate.graphics.drawLine(prevX, prevY, x, y)
	prevX = x
	prevY = y
  end
end

-- example usage:
function playdate.update()
  -- curves are just drawn as a bunch of lines, so you can tweak line settings like width, cap, color, etc
  gfx.setLineWidth(2)
  drawQuadraticBezier(
	10, 80,  -- curve start x,y coordinate
	200, 50, -- control x,y coordinate - your curve will be "pulled" towards this point
	390, 80, -- curve end x,y coordinate
	8 -- number of line segments used to draw the curve, 8 is probably plenty to get a smooth curve
  )
  drawCubicBezier(
	10, 160,  -- curve start x,y coordinate
	100, 110, -- first control x,y coordinate
	300, 210, -- seccond control x,y coordinate
	390, 160, -- curve end x,y coordinate
	12 -- number of line segments used to draw the curve
end

-- Nic Magnier
function getSvgPaths( svg_filepath )
	local file, file_error = playdate.file.open( svg_filepath, playdate.file.kFileRead )
	assert(file, "getSvgPaths(), Cannot open file", svg_filepath," (",file_error,")")

	local push = table.insert
	local commandArgCount = { M=2, L=2, T=2, H=1, V=1, C=6, S=6, A=7, Z=0}

	-- read the whole file
	local fileContent = ""
	repeat
		local line = file:readline()
		if line then
			fileContent = fileContent..line
		end
	until not line

	local result = table.create( 8 )
	for path in fileContent:gmatch("<path.-/>") do
		local previousX, previousY = 0, 0
		local newPath = table.create( 8 )

		local name = path:match("id=\"(.-)\"")
		if not name then name = #result + 1 end
		result[name] = newPath

		local d_content = path:match(" d=\"(.-)\"")
		for command in d_content:gmatch("%a[%-%d%., ]*") do
			local first_character = command:sub(1,1)
			local command_letter = first_character:upper()
			local absolute_coordinates = command_letter==first_character

			local args = table.create( 6 )
			for number in command:gmatch("[-%d%.]+") do
				push(args, tonumber(number))
			end
			local argCount = commandArgCount[ command_letter ]

			local argIndex = 0
			while argIndex+argCount<=#args do
				local relativeX, relativeY = 0, 0
				if not absolute_coordinates then
					relativeX, relativeY = previousX, previousY
				end

				if command_letter=="M" or command_letter=="L" or command_letter=="T" then
					push( newPath, args[argIndex+1] + relativeX)
					push( newPath, args[argIndex+2] + relativeY)
				elseif command_letter=="H" then
					push( newPath, args[argIndex+1] + relativeX)
					push( newPath, previousY)
				elseif command_letter=="V" then
					push( newPath, previousX)
					push( newPath, args[argIndex+1] + relativeY)
				elseif command_letter=="C" then
					push( newPath, args[argIndex+5] + relativeX)
					push( newPath, args[argIndex+6] + relativeY)
				elseif command_letter=="S" then
					push( newPath, args[argIndex+3] + relativeX)
					push( newPath, args[argIndex+4] + relativeY)
				elseif command_letter=="A" then
					push( newPath, args[argIndex+6] + relativeX)
					push( newPath, args[argIndex+7] + relativeY)
				elseif command_letter=="Z" then
					push( newPath, newPath[1])
					push( newPath, newPath[2])
				end

				previousX = newPath[#newPath-1]
				previousY = newPath[#newPath]

				argIndex = argIndex + math.max(argCount, 1)
			end
		end
	end

	for rect in fileContent:gmatch("<rect.-/>") do
		local width = tonumber( rect:match("width=\"([-%d%.]+)\"") )
		local height = tonumber( rect:match("height=\"([-%d%.]+)\"") )
		local x = tonumber( rect:match("x=\"([-%d%.]+)\"") )
		local y = tonumber( rect:match("y=\"([-%d%.]+)\"") )

		local name = rect:match("id=\"(.-)\"")
		if not name then name = #result + 1 end
		result[name] = {
			x, y,
			x+width, y,
			x+width, y+height,
			x, y+height,
			x, y,
		}
	end

	return result
end