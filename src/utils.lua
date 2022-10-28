-- import "mathExtensions"
-- import "party"

local timeDT = playdate.getCurrentTimeMilliseconds
local _lastDT = timeDT()
local gfx = playdate.graphics
local lerp = math.lerp
local TAU = math.TAU

COLORS = {
	black = gfx.kColorBlack,
	white = gfx.kColorWhite,
	transparent = gfx.kColorClear,
	xor = gfx.kColorXOR
}

---Returns the delta time in seconds.
---@return number
function GetDeltaTime()
	--FIXME NEEDS TO BE CALLED EVERY TIME you need to reset the timer as well
	local now = timeDT()
	local dt = now - _lastDT
	_lastDT = now

	return dt * 0.001
end

local checkerBoardpattern = { 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 }

local shakeTime = 0
local shakeStrength = 2

function UpdateShakeScreen(dt)
	if shakeTime > 0 then
		shakeTime = shakeTime - dt
		gfx.setDrawOffset(
			math.random() * 5, math.random() * 5
		)
		-- playdate.display.setInverted(false)
	end
end

function ShakeScreen(time)
	shakeTime = time
end

local bloodTime = 0

function UpdateBlood(dt)
	--FIXME não ta desenhando. Não sei porque
	if bloodTime > 0 then
		bloodTime = bloodTime - dt
		gfx.setPattern(checkerBoardpattern)

		gfx.drawRect(0, 0, 500, 300)
	end
end

function FillBlood(time)
	bloodTime = time
end

---Add objectToAdd into list
---@param list table table list
---@param objectToAdd table needs a "enabled" key
function ObjectPooling(list, objectToAdd)
	local found = false

	for i = 1, #list, 1 do
		local o = list[i]
		if not o.enabled then

			list[i] = objectToAdd
			found = true

			break
		end
	end

	if not found then
		list[#list + 1] = objectToAdd
	end
end

local objectPoolingTemplate = ObjectPooling
local tempVector = {}
local random = math.random

---Run 'callback(x,y)', 'subdivisions' times along this line
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param subdivisions number
---@param callback function (x,y)
function RunOnLine(x1, y1, x2, y2, subdivisions, callback)
	for i = 0, 1, (1 / (subdivisions - 1)) do
		local x = lerp(i, x1, x2)
		local y = lerp(i, y1, y2)
		callback(x, y)
	end
end

---Run 'callback(x,y)', 'subdivisions' times along this circle(x,y,r)
---@param x number
---@param y number
---@param r number
---@param subdivisions number
---@param callback function (x,y)
function RunOnCircle(x, y, r, subdivisions, callback)
	-- for i = 0, subdivisions - 1, 1 do
	-- 	local t = i / subdivisions
	-- 	local a = t * TAU

	-- 	local rx = x + (math.cos(a) * r)
	-- 	local ry = y + (math.sin(a) * r)
	-- 	callback(rx, ry)
	-- end

	for i = 1, subdivisions, 1 do
		local a = math.TAU / subdivisions * (i + 1)
		local rx = x + (math.cos(a) * r)
		local ry = y + (math.sin(a) * r)

		callback(rx, ry)
	end
end
