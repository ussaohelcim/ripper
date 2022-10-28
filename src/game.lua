import "mathHelper"
import "utils"
import "props"
import "player"
import "party"

local getDeltaTime = GetDeltaTime
local gfx = playdate.graphics
local drawText = gfx.drawText

local remap = math.remap
local isInBetween = math.isInBetween
local updateTextParticles = UpdateTextParticles
local updateAndDrawProps = UpdateAndDrawProps
local updateBlood = UpdateBlood

local player = Player()
local slice = { x = 0, y = 0, xx = 0, yy = 0, enabled = false }

local soundsPath = "assets/sounds/"
local lowTime = playdate.sound.sampleplayer.new(soundsPath .. "lowLife.wav")
local midTime = playdate.sound.sampleplayer.new(soundsPath .. "midLife.wav")
local fullTime = playdate.sound.sampleplayer.new(soundsPath .. "fullLife.wav")

fullTime:setVolume(0.3)
midTime:setVolume(0.5)
lowTime:setVolume(0.7)

local timeSound = fullTime
-- timeSound:play(1)

-- local self.scoreboard = Highscore("highscore")

local bg = playdate.graphics.image.new(400, 240)

gfx.pushContext(bg)
gfx.setColor(gfx.kColorWhite)
gfx.fillRect(-50, -50, 500, 340)
gfx.popContext()

playdate.graphics.sprite.setBackgroundDrawingCallback(
	function(x, y, width, height)
		bg:draw(0, 0)
	end
)

function PlayerPoint(points)
	GAME.score = GAME.score + points
	-- self.score = self.score + points
	--FIXME
end

local propTypes = {
	none = -1,
	white = 0,
	black = 1,
	particle = 2,
	bonus = 3
}



function Game()
	local self = {}
	self.score = 0
	self._cooldown = 0
	self.scoreboard = Highscore("highscore")
	self.helpText = [[Crank to aim and B to slice!
Slice the dark circles to win]]

	function self.newMatch(matchTime, roundTime)
		self.score = 0
		self._cooldown = 0

		self.matchTime = matchTime + matchTime % roundTime
		self.roundTime = roundTime

		self.player = Player()
		self.time = 0

		self.scoreboard = Highscore("highscore")
		self.highscore = self.scoreboard.highscore.score

		if self.highscore > self.matchTime then
			self.matchTime = self.highscore + self.highscore % roundTime
		end

		ClearProps()
		ClearTextParticles()

		CreateTxtParticle(self.helpText, 100, 200, 4)
	end

	function self.update()

		gfx.sprite.update()

		local dt = getDeltaTime()

		self.time = self.time + dt

		if self.time >= self.matchTime then

			GameOver()
		end

		UpdateShakeScreen(dt)

		self._cooldown = self._cooldown + dt

		if self._cooldown >= self.roundTime then
			self._cooldown = 0
			SpawnProp()
			timeSound:play(1)
		end

		-- gfx.clear()

		updateBlood(dt)

		self.player.update(dt)
		self.player.draw()

		gfx.drawCircleAtPoint(200, 120, remap(
			self._cooldown, 0, self.roundTime, 400, 0
		))

		gfx.setColor(gfx.kColorBlack)

		updateAndDrawProps(dt)

		drawText("score: " .. self.score, 0, 0)
		drawText("highscore: " .. self.highscore, 0, 20)
		drawText("time: " .. self.matchTime - self.time, 0, 40)

		updateTextParticles(dt)
	end

	return self
end

function GameSurvival()
	local self = Game()

	self.lifes = 5
	self.score = 0
	self._cooldown = 0
	self.scoreboard = Highscore("survival")
	self.helpText = [[Crank to aim and B to slice!
Slice the dark circles to win.
You can only hit 5 white circles!]]

	self.newMatch = function()
		self.score = 0
		self._cooldown = 0

		self.matchTime = 60 -- matchTime + matchTime % roundTime
		self.roundTime = 4 --roundTime

		self.player = Player()
		self.time = 0

		self.scoreboard = Highscore("survival")
		self.highscore = self.scoreboard.highscore.score

		ClearProps()
		ClearTextParticles()

		CreateTxtParticle(self.helpText, 100, 200, 4)
	end

	self.update = function()
		gfx.sprite.update()

		local dt = getDeltaTime()

		self.time = self.time + dt

		if self.lifes <= 0 then
			GameOver()
		end

		UpdateShakeScreen(dt)

		self._cooldown = self._cooldown + dt

		if self._cooldown >= self.roundTime then
			self._cooldown = 0
			SpawnProp()
			timeSound:play(1)
		end

		updateBlood(dt)

		player.update(dt)
		player.draw()

		gfx.drawCircleAtPoint(200, 120, remap(
			self._cooldown, 0, self.roundTime, 400, 0
		))

		gfx.setColor(gfx.kColorBlack)

		updateAndDrawProps(dt)

		drawText("score: " .. self.score, 0, 0)
		drawText("highscore: " .. self.highscore, 0, 20)
		drawText("lifes: " .. self.lifes, 0, 40)

		updateTextParticles(dt)
	end

	return self
end

function GameOver()

	GAME.scoreboard.addScore(GAME.score)
	playdate.update = GameOverScreen
end

--TODO criar um menu de verdade
