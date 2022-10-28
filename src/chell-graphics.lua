local gfx = playdate.graphics
local drawCircleAtPoint = playdate.graphics.drawCircleAtPoint

local cos = math.cos
local sin = math.sin
local sqrt = math.sqrt
local TAU = math.pi * 2
local screenW = 400
local screenH = 240

local max = math.max
local min = math.min
local floor = math.floor

local gfx = playdate.graphics
local popContext = gfx.popContext
local pushContext = gfx.pushContext
local clear = gfx.clear
local lockFocus = gfx.lockFocus
local unlockFocus = gfx.unlockFocus
local drawPixel = gfx.drawPixel
local setColor = gfx.setColor
local drawText = gfx.drawText
local setImageDrawMode = gfx.setImageDrawMode
local drawRect = gfx.drawRect
local setDrawOffset = gfx.setDrawOffset
local setPattern = gfx.setPattern
local drawText = gfx.drawText
local drawArc = playdate.graphics.drawArc
local drawTextAligned = gfx.drawTextAligned
local white = gfx.kColorWhite
local black = gfx.kColorBlack
local transparent = gfx.kColorClear
local rad = math.rad
local copyMode = gfx.kDrawModeCopy

local whitePattern = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF }
local lightGrayPattern = { 0xFF, 0xDD, 0xFF, 0x77, 0xFF, 0xDD, 0xFF, 0x77 }
local checkerBoardpattern = { 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 }
local darkGrayPattern = { 0x0, 0x22, 0x0, 0x88, 0x0, 0x22, 0x0, 0x88 }
local blackPattern = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 }
local anotherGray = { 0xFF, 0xAA, 0xFF, 0xAA, 0xFF, 0xAA, 0xFF, 0xAA }

local align_center = kTextAlignment.center
local align_left = kTextAlignment.left
local align_right = kTextAlignment.right

local function isInBetween(value, _min, _max)
	return value >= _min and value <= _max
end

function Graphics()
	local self = {}

	self.color = playdate.graphics.kColorClear

	function self.clear()
		clear()
		setColor(0) --kColorClear
		setImageDrawMode(copyMode)
	end

	---Set the draw mode for images and texts.
	-- - "copy", "inverted", "XOR", "NXOR", "whiteTransparent", "blackTransparent", "fillWhite", or "fillBlack".
	---@param mode string
	function self.setDrawMode(mode)
		setImageDrawMode(mode)
	end

	function self.setColor(color)
		if color > 0 then
			self.color = 0 --kColorBlack
		elseif color <= 0 then
			self.color = 2 --kColorClear
		else
			self.color = 1 --kColorWhite
		end
		gfx.setColor(self.color)
	end

	function self.circle(x, y, r)
		drawCircleAtPoint(x, y, r)
	end

	function self.fillCircle(x, y, r)
		gfx.fillCircleAtPoint(x, y, r)
	end

	---Draw an arc. This use radians.
	function self.arc_r(x, y, r, sa, ea)
		drawArc(x, y, r, rad(sa), rad(ea))
	end

	---Draw an arc. This use degrees.
	function self.arc_d(x, y, r, sa, ea)
		drawArc(x, y, r, sa, ea)
	end

	function self.rect(x, y, w, h, ox, oy)
		drawRect(x + (ox or 0), y + (oy or 0), w, h)
	end

	function self.fillRect(x, y, w, h, ox, oy)
		gfx.fillRect(x + (ox or 0), y + (oy or 0), w, h)
	end

	function self.image(image, x, y, ox, oy)
		image:draw(x + (ox or 0), y + (oy or 0))
	end

	function self.imageCenter(image, x, y)
		image:drawCentered(x, y)
	end

	local _fillPattern

	---comment
	---@param o number [0,..,1] 0 = white, 0.5 = gray, 1 = black
	function self.setFillPatternLevel(o)
		if isInBetween(o, 0.67, 0.9) then
			_fillPattern = darkGrayPattern
		elseif isInBetween(o, 0.34, 0.66) then
			_fillPattern = checkerBoardpattern
		elseif isInBetween(o, 0.1, 0.33) then
			_fillPattern = lightGrayPattern
		end

		if o < 0.1 then
			_fillPattern = whitePattern
		elseif o > 0.9 then
			_fillPattern = blackPattern
		end

		setPattern(_fillPattern)

	end

	local fontHeight = playdate.graphics.getFont():getHeight()
	local fontHeightMid = fontHeight * 0.5

	function self.text(txt, x, y, ox, oy)
		drawText(txt, x + (ox or 0), y + (oy or 0))
	end

	---@see error do not use every frame, this generate a lot of garbage
	function self.textRect(txt, x, y, w, h)
		gfx.drawTextInRect(txt, x, y, w, h)
	end

	---@see error do not use every frame, this generate a lot of garbage
	function self.textCenter(txt, x, y)
		drawTextAligned(txt, x, y - fontHeightMid, align_center)
	end

	function self.centerCamera(x, y)
		setDrawOffset(x - (screenW * 0.5), y - (screenH * 0.5))
	end

	function self.grayPattern()
		setPattern(checkerBoardpattern)
	end

	function self.blendImages(back, front)
		local backW, backH = back:getSize()
		local frontW, frontH = front:getSize()
		local img = gfx.image.new(
			backW > frontW and backW or frontW,
			backH > frontH and backH or frontH
		)
		lockFocus(img)
		back:draw(0, 0)
		front:draw(0, 0)
		unlockFocus()
		return img
	end

	function self.getCircleImage(r, filled, pattern)
		local img = gfx.image.new(r * r, r * r)
		lockFocus(img)
		if filled then
			gfx.fillCircleAtPoint(r, r, r)
		else
			drawCircleAtPoint(r, r, r)
		end
		unlockFocus()
		return img
	end

	function self.getRectImage(w, h, filled, pattern)
		local img = gfx.image.new(w, h)
		gfx.lockFocus(img)
		if filled then
			gfx.fillRect(0, 0, w, h)
		else
			gfx.drawRect(0, 0, w, h)
		end
		gfx.unlockFocus()
		return img
	end

	function self.generateImage(callback, w, h)
		local img = gfx.image.new(w or 400, h or 240)
		gfx.lockFocus(img)
		callback()
		gfx.unlockFocus()
		return img
	end

	return self
end

function Image(path, ox, oy)
	local s = {}

	s.img = gfx.image.new(path)
	s.originX = ox or 0
	s.originY = oy or 0

	function s.draw(x, y)
		s.img:draw(x + s.originX, y + s.originY)
	end

	return s
end

--TODO implementar os tutorials no inicio
