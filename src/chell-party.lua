local function particleObjectPooling(list, x, y, ttl, gravityX, gravityY)
	local found = false

	for i = 1, #list, 1 do
		local o = list[i]
		if o.ttl <= 0 then

			list[i].x = x
			list[i].y = y
			list[i].ttl = ttl
			list[i].maxttl = ttl
			list[i].gravityX = gravityX
			list[i].gravityY = gravityX

			found = true
			break
		end
	end

	if not found then
		list[#list + 1] = {
			x = x, y = y,
			ttl = ttl, maxttl = ttl,
			gravityX = gravityX, gravityY = gravityY,
		}
	end
end

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
	)
		particleObjectPooling(self.particles, x, y, ttl, gravityX or 0, gravityY or 0)
	end

	function self.updateAndDraw(dt)
		for i = 1, #self.particles, 1 do
			local p = self.particles[i]
			if p.ttl > 0 then
				p.ttl = p.ttl - dt

				p.x = p.x + p.gravityX
				p.y = p.y + p.gravityY

				self.image:draw(p.x, p.y)

			end
		end
	end

	return self
end

---Particle system using chell-animation as the
---@param animation any
---@return table
function AnimatedPARTY(animation)
	local self = {}
	self.particles = {}
	self.image = animation.image
	self.duration = animation.totalTime

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
	)
		particleObjectPooling(self.particles, x, y, self.duration, gravityX or 0, gravityY or 0)
	end

	function self.updateAndDraw(dt)
		for i = 1, #self.particles, 1 do
			local p = self.particles[i]
			if p.ttl > 0 then
				p.ttl = p.ttl - dt

				p.x = p.x + p.gravityX
				p.y = p.y + p.gravityY

				p.update(dt)

				self.image:draw(p.x, p.y)
			end
		end
	end

	return self
end

function PartySystem(particles)
	local self = {}
	self.particles = particles

	function self.updateAndDraw(dt)
		for i = 1, #self.particles, 1 do
			local p = self.particles[i]
			p.updateAndDraw(dt)
		end
	end

	return self
end

function TextParticles()
	local s = {}

	function s.updateAndDraw(dt)

	end

	return s
end
