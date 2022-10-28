local rad = math.rad
local gfx = playdate.graphics
local random = math.random
local setDrawOffset = gfx.setDrawOffset
local shakeTime = 0
local shakeStrength = 2

function UpdateShakeScreen(dt)
	if shakeTime > 0 then
		shakeTime = shakeTime - dt
		setDrawOffset(
			random() * 5, random() * 5
		)
	end
end

function ShakeScreen(time)
	shakeTime = time
end

local tempVector = { x = 0, y = 0 }

local addSlice = AddSlice
local shakeScreen = ShakeScreen
local updateShakeScreen = UpdateShakeScreen

local checkerBoardpattern = { 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 }

local sliceSFX = playdate.sound.sampleplayer.new("assets/sounds/dash.wav")

local getCrankPosition = playdate.getCrankPosition
local drawLine = gfx.drawLine

local buttonJustPressed = playdate.buttonJustPressed
local b_btn = playdate.kButtonB

local m = Math()


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

	function self.update(dt)
		updateShakeScreen(dt)
		self.a = rad(getCrankPosition() - 90)

		if buttonJustPressed(b_btn) then
			sliceSFX:play(1)
			addSlice(self.x, self.y, self.xx, self.yy)
			shakeScreen(0.1)
		end

	end

	function self.draw()

		gfx.setPattern(checkerBoardpattern)

		m.angleToUnitVector(self.a, tempVector)

		self.x = x - tempVector.x * 600
		self.xx = x + tempVector.x * 600

		self.y = y - tempVector.y * 600
		self.yy = y + tempVector.y * 600

		drawLine(
			self.x, self.y,
			self.xx, self.yy
		)

	end

	return self
end
