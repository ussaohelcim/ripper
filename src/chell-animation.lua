-- function Animator()
-- 	local self = {}
-- 	self.animations = {}

-- 	function self.addAnimation(id, animation)
-- 		self.animations[id] = animation
-- 	end

-- 	function self.updateAndDraw()
-- 		for i = 1, #self.animations, 1 do
-- 			local a = self.animations[i]
-- 		end
-- 	end

-- 	return self
-- end

---Returns an animation table
---@param frameList Frame list of frames (Frame())
---@param loop boolean is this animation loopable?
---@return table
function Animation(frameList, loop)
	local self = {}
	self.cursorPosition = 1
	self.size = #frameList
	self.image = frameList[self.cursorPosition].image
	self.timeToNext = frameList[self.cursorPosition].duration
	self.loop = loop

	self.totalTime = 0

	for i = 1, #frameList, 1 do
		self.totalTime = self.totalTime + frameList[i].duration
	end

	function self.update(dt)
		self.timeToNext = self.timeToNext - dt

		if self.timeToNext <= 0 and self.loop then
			self.cursorPosition = self.cursorPosition + 1

			if self.cursorPosition > self.size then
				self.cursorPosition = 1
			end

			self.image = frameList[self.cursorPosition].image
			self.timeToNext = frameList[self.cursorPosition].duration
		end
	end

	function self.draw(x, y)
		self.image:draw(x, y)
	end

	return self
end

function Frame(imgPath, duration)
	local self = {}

	self.image = playdate.graphics.image.new(imgPath)
	self.duration = duration

	return self
end
