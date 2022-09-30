function Highscore(filename)
	local self = {}

	self.highscore = playdate.datastore.read(filename) or {
		score = 0
	}

	local function saveScore()
		playdate.datastore.write(self.highscore, filename)
	end

	function self.addScore(score)
		if score > self.highscore.score then
			self.highscore.score = score
			saveScore()
		end
	end

	return self
end
