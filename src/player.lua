local tempVector = { x = 0, y = 0 }
local angleToNormalizedVector = math.AngleToNormalizedVector
local rad = math.rad
local gfx = playdate.graphics
local addSlice = AddSlice
local shakeScreen = ShakeScreen

local checkerBoardpattern = { 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 }

local sliceSFX = playdate.sound.sampleplayer.new("assets/sounds/dash.wav")

function Player()
	local self = {}
	local x = 200
	local y = 120
	self.x = 0
	self.y = 0
	self.a = 0
	self.holding = false
	self.xx = 0
	self.yy = 0

	playdate.BButtonDown = function()
		sliceSFX:play(1)
		addSlice(self.x, self.y, self.xx, self.yy)
		shakeScreen(0.1)
	end

	function self.update(dt)
		self.a = rad(playdate.getCrankPosition() - 90)

	end

	function self.draw()
		gfx.setPattern(checkerBoardpattern)

		angleToNormalizedVector(self.a, tempVector)

		self.x = x - tempVector.x * 600
		self.xx = x + tempVector.x * 600

		self.y = y - tempVector.y * 600
		self.yy = y + tempVector.y * 600

		gfx.drawLine(
			self.x, self.y,
			self.xx, self.yy
		)

	end

	return self
end
