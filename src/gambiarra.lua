function Jogo()
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

		player.update(dt)
		player.draw()

		gfx.drawCircleAtPoint(200, 120, remap(
			self._cooldown, 0, self.roundTime, 400, 0
		))

		gfx.setColor(gfx.kColorBlack)

		updateAndDrawProps(dt)

		drawText("score: " .. self.score, 0, 0)
		drawText("highscore: " .. self.highscore, 0, 20)
		drawText("time: " .. self.matchTime - self.time, 0, 40)

		updateTextParticles(dt)

		-- AddSlice()
	end

	return self
end

function JogoArcade()
	local self = Jogo()



	return self
end
