-- gfx.kColorClear --2
-- gfx.kColorBlack --0
-- gfx.kColorWhite --1

local getTime = playdate.getCurrentTimeMilliseconds

local gfx = playdate.graphics
local popContext = gfx.popContext
local pushContext = gfx.pushContext
local clear = gfx.clear
local lockFocus = gfx.lockFocus
local unlockFocus = gfx.unlockFocus
local drawPixel = gfx.drawPixel
local setColor = gfx.setColor
local drawText = gfx.drawText

local white = gfx.kColorWhite
local black = gfx.kColorBlack
local transparent = gfx.kColorClear

--- 0 = white
--- 1 = black
--- -1 = clear
local function playdateColorToChellColor(color)
	if color == 0 then --kColorBlack
		return 1
	elseif color <= 0 then --kColorClear
		return -1
	end
	return 0 --kColorWhite
end

function ShaderUtils()
	local self = {}

	---Returns the pixel color.
	-- 0 = white
	-- 1 = black
	-- -1 = clear
	---@return integer
	function self.texture(img, x, y)
		return playdateColorToChellColor(
			self.img:sample(x, y)
		)
	end

	return self
end

function FragmentShader(width, height)
	local self = {}

	self.w = width
	self.h = height
	self.img = gfx.image.new(self.w, self.h)

	---Called for every pixel. MUST return -1,0,1.
	--  - 0 = white
	--  - 1 = black
	--  - -1 = clear
	---@param x number x position inside [0,width)
	---@param y number y position inside [0,height)
	---@return number
	function self.frag(x, y, dt) end

	---Returns a playdate image of this fragment shader
	function self.toImage()
		self.update(1)

		return self.img

	end

	function self.update(dt)
		lockFocus(self.img)

		clear()

		for y = 0, self.h - 1, 1 do
			for x = 0, self.w - 1, 1 do
				if self.frag(x, y, dt) == 1 then
					setColor(black)
					drawPixel(x, y)
				elseif self.frag(x, y, dt) == 0 then
					setColor(white)
					drawPixel(x, y)
				end
			end
		end

		unlockFocus()
	end

	return self
end

function TextShader(txt, x, y, w)
	local s = FragmentShader(400, 240)

	local text = {}
	local _w = w or 10
	for i = 1, #txt, 1 do
		local c = string.sub(txt, i, i)
		text[i] = c
	end

	s.shaderList = {}
	s.x = x
	s.y = y

	function s.frag(_x, _y, i, dt) end

	function s.update(dt)
		lockFocus(s.img)
		clear()

		for i = 1, #text, 1 do
			local nx, ny = s.frag(
				s.x + (_w * (i - 1)), s.y, i, dt
			)
			drawText(text[i], nx, ny)
		end
		unlockFocus()
	end

	return s
end
