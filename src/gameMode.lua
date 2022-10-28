local updateTextParticles = UpdateTextParticles
local clearTextParticles = ClearTextParticles
local createTxtParticle = CreateTxtParticle
local setTimeScale = SetTimeScale

local gfx = Graphics()
local m = Math()
local floor = math.floor

local propTypes = {
	white = 0,
	black = 1,
	particle = 2,
	bonus = 3
}

local whiteCircle = gfx.generateImage(function()
	gfx.circle(16, 16, 16)
end, 32, 32)
local darkCircle = gfx.generateImage(function()
	gfx.fillCircle(16, 16, 16)
end, 32, 32)
local grayCircle = gfx.generateImage(function()
	gfx.grayPattern()
	gfx.fillCircle(16, 16, 16)
end, 32, 32)
local grayNotFilledCircle = gfx.generateImage(function()
	gfx.grayPattern()
	gfx.circle(16, 16, 16)
end, 32, 32)

local waveStartSound = playdate.sound.sampleplayer.new("assets/sounds/fullLife.wav")
local hitSFX = playdate.sound.sampleplayer.new("assets/sounds/hit.wav")

function RipperGame()
	local s = {}
	s.name = "game"
	s.helpText = [[Crank to aim and B to slice!
Slice the dark circles to earn points.
If you slice the white circles, you will lose points.]]
	s.score = 0
	s.waveTotalTime = 4
	s.waveTime = 0

	s.scoreboard = Highscore(s.name)

	-- local scoreboard = Highscore(s.name)
	s.highscore = s.scoreboard.score

	s.propper = DefaultPropper()

	s.propper.collisionCallback = function(prop)
		if prop.type == propTypes.white then
			s.score = s.score - 1
		elseif prop.type == propTypes.black then
			s.score = s.score + 1
		end
	end

	s.propper.drawCallback = function(prop)
		if prop.type == propTypes.white then
			-- gfx.circle(prop.x, prop.y, prop.r)
			-- drawWhiteCircle(prop.x, prop.y)
			gfx.imageCenter(whiteCircle, prop.x, prop.y)
		elseif prop.type == propTypes.black then
			-- gfx.image(darkCircle, prop.x, prop.y, 16, 16)
			-- drawDarkCircle(prop.x, prop.y)
			gfx.imageCenter(darkCircle, prop.x, prop.y)
			-- gfx.fillCircle(prop.x, prop.y, prop.r)
		else --particle
			-- drawGrayCircle(prop.x, prop.y)
			gfx.imageCenter(grayCircle, prop.x, prop.y)
			-- gfx.image(grayCircle, prop.x, prop.y, 16, 16)
			-- gfx.grayPattern()
			-- gfx.fillCircle(prop.x, prop.y, prop.r)
		end
	end

	function s.update(dt) end

	function s.draw(dt) end

	function s.handleEndGame() end

	function s.startWave()
		waveStartSound:play(1)
		s.propper.spawnProps()
	end

	function s.handleWave(dt)
		s.waveTime = s.waveTime + dt

		if s.waveTime >= s.waveTotalTime then
			s.waveTime = 0
			s.startWave()
		end
		s.handleEndGame()
	end

	s.gameOverText = ""

	function s.gameOver()
		s.gameOverText = "GAME OVER." ..
				"\nscore: " .. s.score ..
				"\nhighscore: " .. s.highscore ..
				(m.iff(s.score > s.highscore, "\nNEW HIGHSCORE!", ""))

		s.save()

		gfx.centerCamera(200, 120)
		playdate.update = s.gameOverScreen
	end

	function s.gameOverScreen()
		--TODO melhorar tela de game over

		gfx.clear()


		gfx.textCenter(s.gameOverText, 200, 50)
		-- gfx.text(s.gameOverText, 20, 50)

		-- gfx.textRect(s.gameOverText, 0, 0, 400, 240)
		-- gfx.textC("Press MENU to go to the game main menu", 20, 200)

		gfx.textCenter("Press MENU to restart \nor to go the game main menu", 200, 200)
	end

	function s.save()
		s.scoreboard.addScore(s.score)
	end

	function s.refreshHighscore()
		s.scoreboard = Highscore(s.name)
		s.highscore = s.scoreboard.score
	end

	return s
end

function Survival()
	local s = RipperGame()
	s.name = "Survival"
	s.helpText = [[Crank to aim and B to slice!
Slice the dark circles to earn points. 
If you slice 5 white circle, its game over.]]
	local lives = 5
	local player = Player()
	local hungry = 0
	local hungryMax = s.waveTotalTime + (s.waveTotalTime * 0.3)

	s.scoreboard = Highscore(s.name)

	createTxtParticle(s.helpText, 0, 180, 2)

	s.refreshHighscore()

	s.propper.collisionCallback = function(prop)
		if prop.type == propTypes.white then
			s.hurt()
			createTxtParticle('-1 life', prop.x, prop.y)
		elseif prop.type == propTypes.black then
			s.score = s.score + 1
			createTxtParticle('+1 point', prop.x, prop.y, 1)
			hitSFX:play(1)
		end
		prop.enabled = false
		s.propper.spawnDeadProp(prop.x, prop.y)
		hungry = 0
	end

	function s.hurt()
		lives = lives - 1

	end

	s.update = function(dt)

		hungry = hungry + dt
		if hungry >= hungryMax then
			s.hurt()
			createTxtParticle('- 1 life, im hungry!', 200, 120)
			hungry = 0
		end

		player.update(dt)

		s.handleWave(dt)
	end

	s.draw = function(dt)
		gfx.clear()

		s.propper.updateAndDraw(dt)

		gfx.circle(
			200, 120,
			m.remap(s.waveTime, 0, s.waveTotalTime, 400, 0)
		)
		player.draw()

		updateTextParticles(dt)

		local h = floor(m.remap(hungry, 0, hungryMax, 0, 100))

		gfx.text("lives: " ..
			lives .. "\nhunger: " .. h .. "%\nscore: " .. s.score .. "\nhighscore: " .. s.highscore,
			10, 10
		)
	end

	s.handleEndGame = function()
		if lives <= 0 then
			s.gameOver()
		end
	end

	return s
end

function TimedGame(time)
	local s = RipperGame()
	s.name = ""
	---The total time of the match
	s.totalTime = time + (time % s.waveTotalTime)
	s._time = 0

	s.handleEndGame = function()
		if s._time > s.totalTime then
			s.gameOver()
		end
	end

	return s
end

function Classic()
	local time = 60
	local s = TimedGame(time)

	s.helpText = [[Crank to aim and B to slice!
Slice the dark circles to earn points.]]

	s.name = 'Classic'
	-- s.scoreboard = Highscore(s.name)

	s.refreshHighscore()
	createTxtParticle(s.helpText, 0, 180, 2)

	if s.scoreboard.score > s.totalTime then
		if s.scoreboard.score % s.waveTotalTime ~= 0 then
			s.totalTime = m.nextMultipleOf(s.scoreboard.score, s.waveTotalTime)
		else
			s.totalTime = s.scoreboard.score
		end
	end
	print("time", s.totalTime, "highscore", s.scoreboard.score)
	--TODO implementar o modo classico
	local player = Player()

	local combo = 0
	local _score = 0

	s.propper.collisionCallback = function(prop)
		if prop.type == propTypes.white then
			_score = _score - 1
			-- s.score = s.score - 1
			createTxtParticle('-1', prop.x, prop.y)
		elseif prop.type == propTypes.black then
			combo = combo + 1
			_score = _score + 1
			-- s.score = s.score + 1
			hitSFX:play(1)
			createTxtParticle('+1', prop.x, prop.y)
		end
		prop.enabled = false
		s.propper.spawnDeadProp(prop.x, prop.y)
	end

	s.propper.drawCallback = function(prop)
		if prop.type == propTypes.white then
			gfx.imageCenter(whiteCircle, prop.x, prop.y)
			-- gfx.circle(prop.x, prop.y, prop.r)
		elseif prop.type == propTypes.black then
			gfx.imageCenter(darkCircle, prop.x, prop.y)
			-- gfx.fillCircle(prop.x, prop.y, prop.r)
		else --particle
			gfx.imageCenter(grayCircle, prop.x, prop.y)
			-- gfx.grayPattern()
			-- gfx.fillCircle(prop.x, prop.y, prop.r)
		end
	end

	s.update = function(dt)
		s._time = s._time + dt
		player.update(dt)


		s.handleWave(dt)
	end

	s.draw = function(dt)
		gfx.clear()
		s.propper.updateAndDraw(dt)

		s.score = s.score + (_score * m.iff(combo == 0, 1, combo))
		if combo > 1 then

			createTxtParticle("COMBO x" .. combo, 200, 210)
		end
		_score = 0
		combo = 0

		gfx.grayPattern()
		gfx.circle(
			200, 120,
			m.remap(s.waveTime, 0, s.waveTotalTime, 400, 0)
		)

		player.draw()

		updateTextParticles(dt)

		gfx.text("time left: " ..
			s.totalTime - s._time .. "\nscore: " .. s.score .. "\nhighscore: " .. s.highscore,
			10, 10
		)
	end


	return s
end

function Arcade()
	local s = TimedGame(60)
	s.name = "Arcade"
	local combo = 0
	local player = Player()


	s.helpText = [[Crank to aim and B to slice!
Slice the dark circles to earn points.]]

	-- s.scoreboard = Highscore(s.name)
	s.refreshHighscore()
	createTxtParticle(s.helpText, 0, 180, 2)

	s.propper.collisionCallback = function(prop)
		if prop.type == propTypes.white then
			combo = 0
			createTxtParticle('combo reseted', 200, 120)
		elseif prop.type == propTypes.black then
			combo = combo + 1
			s.score = s.score + combo
			createTxtParticle('+ ' .. combo, prop.x, prop.y)
			hitSFX:play(1)
		end
		s.propper.spawnDeadProp(prop.x, prop.y)
		prop.enabled = false
	end

	s.update = function(dt)
		s._time = s._time + dt
		player.update(dt)

		s.handleWave(dt)
	end

	s.draw = function(dt)
		gfx.clear()
		s.propper.updateAndDraw(dt)

		gfx.circle(
			200, 120,
			m.remap(s.waveTime, 0, s.waveTotalTime, 400, 0)
		)

		player.draw()

		updateTextParticles(dt)

		gfx.text("time left: " ..
			s.totalTime - s._time .. "\ncombo: " .. combo .. "\nscore: " .. s.score .. "\nhighscore: " .. s.highscore,
			10, 10
		)
	end

	return s
end

function Weird()
	local s = TimedGame(60)
	s.name = "Weird"

	--slice empty

	s.helpText = [[Crank to aim and B to slice!
If you slice a circle, you will lose 1 life.]]

	s.propper = WeirdPropper()

	createTxtParticle(s.helpText, 0, 180, 2)

	s.scoreboard = Highscore(s.name)
	s.highscore = s.scoreboard.score

	s.waveTotalTime = 2

	local lifes = 10
	local hungry = 0
	local hungryMax = s.waveTotalTime * 2
	local player = Player()

	s.propper.drawCallback = function(prop)
		if prop.type == propTypes.particle then
			-- gfx.grayPattern()
			-- gfx.fillCircle(prop.x, prop.y, prop.r)
			gfx.imageCenter(grayCircle, prop.x, prop.y)
		else
			gfx.imageCenter(grayNotFilledCircle, prop.x, prop.y)
			-- gfx.grayPattern()
			-- gfx.circle(prop.x, prop.y, prop.r)
		end
	end

	s.propper.collisionCallback = function(prop)
		s.hurt()
		prop.enabled = false
		createTxtParticle("-life", prop.x, prop.y)
	end

	s.propper.slicedEmptyCallback = function()
		hitSFX:play(1)
		createTxtParticle("+1", 200, 120, 0.1)
		s.score = s.score + 1
		hungry = 0
	end

	s.hurt = function()
		lifes = lifes - 1
	end

	s.update = function(dt)
		hungry = hungry + dt
		if hungry >= hungryMax then
			s.hurt()
			createTxtParticle('- 1 life, im hungry!', 200, 120)
			hungry = 0
		end

		player.update(dt)

		s.handleWave(dt)
	end

	s.draw = function(dt)
		gfx.clear()
		s.propper.updateAndDraw(dt)

		gfx.circle(
			200, 120,
			m.remap(s.waveTime, 0, s.waveTotalTime, 400, 0)
		)

		player.draw()

		updateTextParticles(dt)

		-- gfx.text("time left: " ..
		-- 	s.totalTime - s._time .. "\nscore: " .. s.score .. "\nhighscore: " .. s.highscore,
		-- 	10, 10
		-- )
		local h = floor(m.remap(hungry, 0, hungryMax, 0, 100))

		gfx.text("lives: " ..
			lifes .. "\nhunger: " .. h .. "%\nscore: " .. s.score .. "\nhighscore: " .. s.highscore,
			10, 10
		)
	end

	s.handleEndGame = function()
		if lifes <= 0 then
			s.gameOver()
		end
	end
	return s
end

function Crazy()
	--FIXME tem algum bug estranho aqui

	local s = TimedGame(60)
	s.propper = CrazyPropper()
	local player = Player()
	-- local m = Math()

	s.name = "Crazy"
	s.waveTotalTime = 2
	s.helpText = [[Crank to aim and B to slice!
Slice the dark circles to earn points.]]
	s.scoreboard = Highscore(s.name)

	s.refreshHighscore()
	createTxtParticle(s.helpText, 0, 180, 2)

	s.propper.drawCallback = function(prop)
		if prop.type == propTypes.particle then
			-- gfx.grayPattern()
			-- gfx.fillCircle(prop.x, prop.y, prop.r)
			gfx.imageCenter(grayCircle, prop.x, prop.y)
		else
			gfx.imageCenter(darkCircle, prop.x, prop.y)
			-- gfx.fillCircle(prop.x, prop.y, prop.r)
		end
	end

	s.propper.collisionCallback = function(prop)
		local points = floor(m.sqrDistance(200, 120, prop.x, prop.y))
		s.score = s.score + points
		prop.enabled = false
		createTxtParticle("+" .. points, prop.x, prop.y)
		hitSFX:play(1)
		s.propper.spawnDeadProp(prop.x, prop.y)
	end

	s.update = function(dt)
		s._time = s._time + dt
		player.update(dt)

		s.handleWave(dt)
	end

	s.draw = function(dt)
		gfx.clear()
		s.propper.updateAndDraw(dt)

		gfx.circle(
			200, 120,
			m.remap(s.waveTime, 0, s.waveTotalTime, 400, 0)
		)

		player.draw()

		updateTextParticles(dt)

		gfx.text("time left: " ..
			s.totalTime - s._time .. "\nscore: " .. s.score .. "\nhighscore: " .. s.highscore,
			10, 10
		)
	end
	-- s.handleEndGame = function()

	-- end
	return s
end

-- function Template()
-- 	local s = RipperGame()
-- 	s.name = "GameName"

-- 	s.scoreboard = Highscore(s.name)

-- 	s.propper.drawCallback = function(prop)
-- 	end

-- 	s.propper.collisionCallback = function(prop)
-- 	end

-- 	s.update = function(dt)
-- 	end

-- 	s.draw = function(dt)

-- 	end
-- 	s.handleEndGame = function()
-- 		-- if lives <= 0 then
-- 		-- 	s.gameOver()
-- 		-- end
-- 	end
-- 	return s
-- end

--TODO mostrar um pequeno tutorial no inicio das partidas
--TODO desenhar imagem inves dos circulos(pra desenhar os circulos precisa de matematica por baixo)
