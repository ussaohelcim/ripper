local remap = math.remap
local lerp = math.lerp
local objectPooling = ObjectPooling
local gfx = playdate.graphics

---Creates a particle system with this img
---@param img image playdate image
function PARTY(img)
	local self = {}
	self.particles = {}
	self.image = img

	---Creates this particle at x,y
	---@param x number
	---@param y number
	---@param ttl number Time to live, in seconds.
	---@param gravityX number
	---@param gravityY number
	function self.createParticle(
	  x, y,
	  ttl,
	  gravityX, gravityY
	  -- scaleStart, scaleEnd
	  -- opacityStart, opacityEnd
	)
		local p = {}
		p.x = x
		p.y = y

		p.ttl = ttl
		p.maxttl = ttl

		p.gravityX = gravityX or 0
		p.gravityY = gravityY or 0

		-- p.initialScale = scaleStart or 1
		-- p.finalScale = scaleEnd or 1
		-- p.scale = 0

		objectPooling(self.particles, p)

	end

	function self.updateAndDraw(dt)
		for i = 1, #self.particles, 1 do
			local p = self.particles[i]
			if p.ttl > 0 then
				p.ttl = p.ttl - dt

				-- local progress = 1 - remap(p.ttl, 0, p.maxttl, 0, 1)

				-- p.scale = lerp(progress, p.initialScale, p.finalScale)

				p.x = p.x + p.gravityX
				p.y = p.y + p.gravityY

				self.image:draw(p.x, p.y)

			end
		end
	end

	return self
end

local txtParticles = {}

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

	function self.update(dt)
		self.ttl = self.ttl - dt

		gfx.drawTextAligned(self.txt, self.x, self.y, kTextAlignment.center)

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
	handleParticleCreation(txt, x, y, ttl)
end
