local tempVector = { x = 0, y = 0 }
local angleToNormalizedVector = math.AngleToNormalizedVector
local rad = math.rad
local gfx = playdate.graphics
local shakeScreen = ShakeScreen
local checkerBoardpattern = { 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 }
local checkCollisionLineCircle = math.checkCollisionLineCircle

function MenuList(list)
	local self = {}
	self.list = list

	local x = 200
	local y = 120

	function self.init(x, y, r)
		for i = 1, #self.list, 1 do
			local option = self.list[i]
			local a = math.TAU / #self.list * (i)
			local rx = x + (math.cos(a) * r)
			local ry = y + (math.sin(a) * r)

			option.x = rx
			option.y = ry

			-- option.draw(rx, ry)
		end
	end

	function self.draw(x, y, r)
		for i = 1, #self.list, 1 do
			local option = self.list[i]
			-- local a = math.TAU / #self.list * (i + 1)
			-- local rx = x + (math.cos(a) * r)
			-- local ry = y + (math.sin(a) * r)
			-- playdate.graphics.drawCircleAtPoint(x, y, r)
			option.draw()
		end
	end

	function self.update(dt)
		local sliced = false
		if playdate.buttonJustPressed("b") then
			shakeScreen(0.1)
			sliced = true
		end

		local a = math.rad(playdate.getCrankPosition() - 90)

		playdate.graphics.setPattern(checkerBoardpattern)

		angleToNormalizedVector(a, tempVector)

		self.x = x - tempVector.x * 600
		self.xx = x + tempVector.x * 600

		self.y = y - tempVector.y * 600
		self.yy = y + tempVector.y * 600

		playdate.graphics.drawLine(
			self.x, self.y,
			self.xx, self.yy
		)

		for i = 1, #self.list, 1 do
			local option = self.list[i]
			if sliced and checkCollisionLineCircle(self.x, self.y, self.xx, self.yy, option.x, option.y, option.r) then
				option.action()
			end
		end

		UpdateShakeScreen(dt)
		UpdateTextParticles(dt)
	end

	return self
end

function MenuOption(txt, callback, subText)
	local self = {}
	self.r = 16
	self.x = 0
	self.y = 0
	self._txt = txt
	self._subText = subText

	function self.draw(x, y)
		playdate.graphics.drawCircleAtPoint(x or self.x, y or self.y, self.r)
		-- playdate.graphics.drawCircleAtPoint(x or self.x, y or self.y, 2)

		playdate.graphics.drawText(
			self._txt,
			x or self.x + (self.r + 2),
			y or self.y - (self.r)
		)
		playdate.graphics.drawText(
			self._subText,
			x or self.x + (self.r + 2),
			(y or self.y)
		)
	end

	self.action = callback

	return self
end

local scoreArcade = Highscore("arcade")
local scoreClassic = Highscore("highscore")
local scoreSurvival = Highscore("survival")

local menu = MenuList(
	{
		MenuOption("Survival", function()
			print("survival")
		end, scoreSurvival.highscore.score),
		MenuOption("Arcade", function()
			print("arcade")
		end, scoreArcade.highscore.score),
		MenuOption("Classic", function()
			print("classic")
		end, scoreClassic.highscore.score),
	}
)

menu.init(200, 120, 100)
GetDeltaTime()

function MenuScreen()
	local dt = GetDeltaTime()
	playdate.graphics.clear()
	menu.update(dt)
	menu.draw(200, 120, 100)
	playdate.graphics.drawText([[
Select the game mode
Crank to AIM, B to slice]], 0, 80)
end

function OpenMenu()
	playdate.update = MenuScreen
end
