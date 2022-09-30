function UI_Row(children, x, y, w)
	local self = {}
	self.cursorPosition = 1
	self.children = children
	self.x = x
	self.size = #children


	function self.update()
		if playdate.buttonJustPressed("up") then
			self.cursorPosition = self.cursorPosition - 1

			if self.cursorPosition <= 0 then
				self.cursorPosition = self.size
			end

		elseif playdate.buttonJustPressed("down") then
			self.cursorPosition = self.cursorPosition + 1

			if self.cursorPosition > self.size then
				self.cursorPosition = 1
			end
			-- elseif playdate.buttonJustPressed("left") then
			-- elseif playdate.buttonJustPressed("right") then
		elseif playdate.buttonJustPressed("a") then

			if self.children[self.cursorPosition].isAction then
				self.children[self.cursorPosition].callback()
			end

			-- elseif playdate.buttonJustPressed("b") then
		end
	end

	function self.draw()

		for i = 1, #self.children, 1 do
			local c = self.children[i]

			if self.cursorPosition == i then
				playdate.graphics.drawRect(self.x, i * 20, 2000, 20)
			end

			c.draw(self.x, i * 20)
		end
	end

	return self
end

function UI_Text(txt)

end

function UI_Button(txt, callback)
	local self = {}
	self.txt = txt
	self.isAction = true
	-- playdate.graphics.font:getTextWidth(text)

	-- self.h = playdate.mea

	function self.draw(x, y)
		playdate.graphics.drawText(self.txt, x, y)
	end

	self.callback = callback


	return self
end
