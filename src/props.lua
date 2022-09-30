local propList = {}
local particles = {}

local slice = { x = 0, y = 0, xx = 0, yy = 0, enabled = false }
local g = 9
local tempVector = { x = 0, y = 0 }
local angleToNormalizedVector = math.AngleToNormalizedVector
local objectPooling = ObjectPooling
local checkCollisionCircleRect = math.CheckCollisionCircleRect
local random = math.random
local hitSFX = playdate.sound.sampleplayer.new("assets/sounds/hit.wav")
-- local pointSFX = playdate.sound.sampleplayer.new("assets/sounds/point.wav")
-- pointSFX:setVolume(0.3)

local sliceSFX = playdate.sound.sampleplayer.new("assets/sounds/slice.wav")
local checkerBoardpattern = { 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 }
local propTypes = {
	white = 0,
	black = 1,
	particle = 2,
	bonus = 3
}
local gfx = playdate.graphics

local function isCircleInsideScreen(x, y, r)
	return checkCollisionCircleRect(x, y, r, 0, 0, 400, 240)
end

function CreateProp(x, y, a, v, type)
	local self = {}
	self.r = 16

	self.x = x
	self.y = y
	self.a = a
	self.v = v
	self.type = type
	-- self.isGood = good

	function self.update(dt)

		angleToNormalizedVector(self.a, tempVector)
		self.y = self.y + (tempVector.y * (self.v + g)) * dt
		self.x = self.x + (tempVector.x * (self.v)) * dt

		if not isCircleInsideScreen(self.x, self.y, self.r) then
			self.enabled = false

		end
	end

	return self
end

local checkCollisionLineCircle = math.checkCollisionLineCircle

local function isCollidingWithSlice(x, y, r)

	return checkCollisionLineCircle(slice.x, slice.y, slice.xx, slice.yy, x, y, r)
end

local function handlePropCreation(x, y, a, v, type)
	local found = false

	for i = 1, #propList, 1 do
		local o = propList[i]
		if not o.enabled then

			propList[i].x = x
			propList[i].y = y
			propList[i].a = a
			propList[i].v = v
			propList[i].enabled = true
			propList[i].type = type

			found = true

			break
		end
	end

	if not found then
		local p = CreateProp(x, y, a, v, type)
		p.enabled = true
		propList[#propList + 1] = p
	end
end

function UpdateAndDrawProps(dt)
	local amountOfSlices = 0
	local bonus = 0

	for i = 1, #propList, 1 do
		local f = propList[i]
		if f.enabled then

			f.update(dt)

			if not (f.type == propTypes.particle) then
				if slice.enabled then
					if isCollidingWithSlice(f.x, f.y, f.r) then
						f.enabled = false
						if f.type == propTypes.white then
							CreateTxtParticle("-1", f.x, f.y, 2)
							PlayerPoint(-1)
							-- hitSFX:play(1)
							FillBlood(0.1)
							handlePropCreation(f.x, f.y, math.rad(90), 200, propTypes.particle)

						elseif f.type == propTypes.black then
							amountOfSlices = amountOfSlices + 1

							CreateTxtParticle("+1", f.x, f.y, 2)

							handlePropCreation(f.x, f.y, math.rad(-90), 200, propTypes.particle)
						end

						-- handlePropCreation(f.x, f.y, f.a math.rad(180), 100, propTypes.particle)
					end
				end
			end

			if f.type == propTypes.white then
				gfx.drawCircleAtPoint(f.x, f.y, f.r)
			elseif f.type == propTypes.black then
				gfx.fillCircleAtPoint(f.x, f.y, f.r)
			else
				gfx.setPattern(checkerBoardpattern)
				gfx.fillCircleAtPoint(f.x, f.y, f.r)
				gfx.setColor(gfx.kColorBlack)
			end

		end
	end

	for i = 1, #particles, 1 do
		local f = particles[i]

		if f.enabled then
			if slice.enabled then
				if isCollidingWithSlice(f.x, f.y, f.r) then
					f.enabled = false
				end
			end

			f.update(dt)
		end
	end

	if amountOfSlices > 0 then
		-- pointSFX:play(amountOfSlices)
		hitSFX:play(amountOfSlices)
		PlayerPoint(amountOfSlices + amountOfSlices)

		if amountOfSlices > 1 then
			CreateTxtParticle("COMBO x" .. amountOfSlices, 200, 210, 2)
		end
	end

	slice.enabled = false
end

function AddSlice(x, y, xx, yy)
	slice.x = x
	slice.y = y
	slice.xx = xx
	slice.yy = yy
	slice.enabled = true
end

function PreGenerate(amount)
	for i = 1, amount, 1 do
		local tempFruit = CreateProp(
			200, 120,
			math.rad(math.random(0, 360)),
			50,
			false
		)
		tempFruit.enabled = false

		objectPooling(propList, tempFruit)
	end
end

function ClearProps()
	for i = 1, #propList, 1 do
		propList[i].enabled = false
	end
end

function SpawnProp()
	--TODO ir aumentando com o tempo

	local amount = math.random(2, 5)
	amount = amount * 2

	local bonus = math.random(0, 9)

	if bonus > 8 then

	end

	for i = 1, amount * 0.5, 1 do
		handlePropCreation(
			200, 120,
			math.rad(math.random(0, 360)),
			math.random(50, 100),
			propTypes.white
		)

	end

	for i = 1, amount * 0.5, 1 do
		handlePropCreation(
			200, 120,
			math.rad(math.random(0, 360)),
			math.random(50, 100),
			propTypes.black
		)
	end

	-- print("memory: ", collectgarbage("count"))
	-- print("amount of fruits", #propList)
	-- print("amount of particles", #particles)
end
