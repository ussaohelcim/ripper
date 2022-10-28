local txtParticles = {}
local gfx = Graphics()
local getTextSize = playdate.graphics.getTextSize

local function handleParticleCreation(txt, x, y, ttl)
	local found = false

	for i = 1, #txtParticles, 1 do
		local o = txtParticles[i]
		if not o.enabled then
			txtParticles[i].x = x
			txtParticles[i].y = y
			txtParticles[i].ttl = ttl
			txtParticles[i].txt = txt

			txtParticles[i].enabled = true

			found = true

			break
		end
	end

	if not found then
		local p = Partxt(txt, x, y, ttl)
		p.enabled = true
		txtParticles[#txtParticles + 1] = p
	end

end

function Partxt(txt, x, y, ttl)
	local self = {}
	self.x = x
	self.y = y
	self.txt = txt
	self.ttl = ttl
	self.w, self.h = getTextSize(txt)
	self.w = self.w * 0.5
	self.h = self.h * 0.5

	function self.update(dt)
		self.ttl = self.ttl - dt

		-- gfx.text(self.txt, self.x, self.y, -self.w, -self.h)
		gfx.text(self.txt, self.x, self.y)
		if self.ttl <= 0 then
			self.enabled = false
		end
	end

	return self
end

function UpdateTextParticles(dt)
	for i = 1, #txtParticles, 1 do
		local p = txtParticles[i]

		if p.enabled then
			p.update(dt)
		end
	end

end

function ClearTextParticles()
	for i = 1, #txtParticles, 1 do
		txtParticles[i].enabled = false
	end
end

function CreateTxtParticle(txt, x, y, ttl)
	handleParticleCreation(txt, x, y, ttl or 2)
end
