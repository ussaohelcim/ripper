--animation library
-- local anim = Animator(
-- 	{
-- 		Frame("path", 0.3),
-- 		Frame("path", 0.3),
-- 		Frame("path", 0.3),
-- 		Frame("path", 0.3),
-- 	}
-- )
-- anim.update(1)
-- anim.draw(0, 0)


function Animator(frameList)
	local self = {}
	self.cursorPosition = 1
	self.size = #frameList
	self.image = frameList[self.cursorPosition].image
	self.timeToNext = frameList[self.cursorPosition].duration

	function self.update(dt)
		self.timeToNext = self.timeToNext - dt

		if self.timeToNext <= 0 then
			self.cursorPosition = self.cursorPosition + 1

			if self.cursorPosition > self.size then
				self.cursorPosition = 1
			end

			self.image = frameList[self.cursorPosition].image
			self.timeToNext = frameList[self.cursorPosition].duration
		end
	end

	function self.draw(x, y)
		self.image:drawCentered(x, y)
	end

	return self
end

function Frame(imgPath, duration)
	local self = {}

	self.image = playdate.graphics.image.new(imgPath)
	self.duration = duration

	return self
end
