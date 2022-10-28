local sqrt = math.sqrt
local abs = math.abs
local max = math.max
local min = math.min
local floor = math.floor
local cos = math.cos
local sin = math.sin
local TAU = math.pi * 2

function Math()
	--math library
	local self = {}

	---Returns x clamped to the range [a,b]
	---@param x number
	---@param a number
	---@param b number
	---@return number
	function self.clamp(x, a, b)
		return max(a, min(b, x));
	end

	---Returns the scalar dot product of two vectors 1 and 2.
	---@param x1 number
	---@param y1 number
	---@param x2 number
	---@param y2 number
	---@return number
	function self.dot(x1, y1, x2, y2)
		return x1 * x2 + y1 * y2
	end

	function self.nextMultipleOf(offset, value)
		return offset + (value - offset % value)
	end

	---Returns the Euclidean distance from a first point pt1 to a second point pt2.
	---@see self.sqrDistance use the sqrDistance when you dont need the actual distance (ex: comparing distances)
	---@param x1 number
	---@param y1 number
	---@param x2 number
	---@param y2 number
	---@return number
	function self.distance(x1, y1, x2, y2)
		local x, y = x1 - x2, y1 - y2
		return sqrt(x * x + y * y)
	end

	---Returns the square distance from 1 to 2
	---@see self.distance use the distance when you need the actual distance (ex: to print distances)
	function self.sqrDistance(x1, y1, x2, y2)
		local x, y = x1 - x2, y1 - y2
		return x * x + y * y
	end

	---Returns x saturated to the range [0,1] as follows:
	-- 1) Returns 0 if x is less than 0; else
	-- 2) Returns 1 if x is greater than 1; else
	-- 3) Returns x otherwise.
	---@param x number
	---@return integer
	function self.saturate(x)
		return max(0, min(1, x))
	end

	---Returns the Euclidean length of a vector.
	function self.length(x, y)
		return sqrt(x * x + y * y)
	end

	-- local saturate = self.saturate

	---Interpolates smoothly from 0 to 1 based on x compared to a and b.
	-- 1) Returns 0 if x < a < b or x > a > b
	-- 1) Returns 1 if x < b < a or x > b > a
	-- 3) Returns a value in the range [0,1] for the domain [a,b].
	---@param a number
	---@param b number
	---@param x number
	function self.smoothStep(a, b, x)
		local t = self.saturate((x - a) / (b - a));
		return t * t * (3.0 - (2.0 * t));
	end

	---Returns the fractional portion of a scalar or each vector component.
	---@param v number
	---@return integer
	function self.fract(v)
		return v - floor(v)
	end

	---Any value under the limit will return 0.0 while everything above the limit will return 1
	---@param a any the limit or threshold
	---@param x any the value we want to check or pass
	---@return integer
	function self.step(a, x)
		return a >= x and 1 or 0
	end

	---Returns the linear interpolation of a and b based on weight t. (!can be extrapolated!)
	-- 1) a and b are either both scalars or both vectors of the same length. The weight t may be a scalar or a vector of the same length as a and b. t can be any value (so is not restricted to be between zero and one); if t has values outside the [0,1] range, it actually extrapolates.
	---@param src number
	---@param dst number
	---@param value number
	---@return number
	function self.lerp(src, dst, value)
		return src + value * (dst - src);
	end

	---Returns v²
	---@param v number
	---@return number
	function self.square(v)
		return v * v
	end

	---Ternary operator.
	---Usage :num = 3 ; print(m.iff(num == 2,"two","not two")) ---"not two"
	---@param comparison any
	---@param ifTrue any
	---@param ifFalse any
	---@return any
	function self.iff(comparison, ifTrue, ifFalse)
		return comparison and ifTrue or ifFalse
	end

	function self.remap(v, old_min, old_max, new_min, new_max)
		return ((v - old_min) / (old_max - old_min)) * (new_max - new_min) + new_min
	end

	function self.angleToUnitVector(angle, out)
		out.x = cos(angle)
		out.y = sin(angle)
	end

	function self.isInBetween(value, _min, _max)
		return value >= _min and value <= _max
	end

	function self.ping(value, t)
		return (cos(value + t) + 1) * 0.5
	end

	return self
end

function Collision()
	local s = {}
	local m = Math()

	function s.checkCollisionCircles(c1x, c1y, c1r, c2x, c2y, c2r)
		local dx = c2x - c1x
		local dy = c2y - c1y
		local distance = (dx * dx + dy * dy)

		return distance <= (c1r + c2r) * (c1r + c2r)

		-- local distance = sqrt(dx * dx + dy * dy)
		-- return distance <= (c1r + c2r)
	end

	---Slow, this uses sqrt.
	--FIXME não usar sqrt
	function s.checkCollisionPointLine(px, py, x, y, xx, yy)
		local d1 = sqrt((px - x) * (px - x) + (py - y) * (py - y)) --distance between point and line[0]
		local d2 = sqrt((px - xx) * (px - xx) + (py - yy) * (py - yy)) --distance between point and line[1]
		local lineLen = m.distance(x, y, xx, yy)

		return m.isInBetween(d1 + d2, 0, lineLen)
	end

	---só funciona em linhas "infinitas"
	--FIXME não usar sqrt
	--FIXME só funciona em linhas "infinitas"
	function s.checkCollisionCircleLine(cx, cy, cr, x1, y1, x2, y2)

		local dx, dy = x1 - x2, y1 - y2
		local length = sqrt(dx * dx + dy * dy) --distancia
		local dot = (((cx - x1) * (x2 - x1)) + ((cy - y1) * (y2 - y1))) / (length * length)

		local closestX = x1 + (dot * (x2 - x1));
		local closestY = y1 + (dot * (y2 - y1));

		dx = closestX - cx
		dy = closestY - cy

		local distance = sqrt(dx * dx + dy * dy)

		if distance <= cr then
			return true
		end

		return false
	end

	function s.checkCollisionPointCircle(x, y, cx, cy, cr)
		return s.checkCollisionCircles(x, y, 1, cx, cy, cr)
	end

	function s.checkCollisionPointRect(px, py, rx, ry, rw, rh)
		return (px >= rx) and (px <= (rx + rw)) and (py >= ry) and (py <= (ry + rh))
	end

	function s.checkCollisionRects(r1x, r1y, r1w, r1h, r2x, r2y, r2w, r2h)
		return (r1x < (r2x + r2w) and (r1x + r1w) > r2x) and
				(r1y < (r2y + r2h) and (r1y + r1h) > r2y)
	end

	function s.checkColissionCircleRect(rx, ry, rw, rh, cx, cy, cr)
		local collision = false;

		local recCenterX = (rx + rw * 0.5);
		local recCenterY = (ry + rh * 0.5);

		local dx = abs(cx - recCenterX);
		local dy = abs(cy - recCenterY);

		if (dx > (rw * 0.5 + cr)) then
			return false;
		end
		if (dy > (rh * 0.5 + cr)) then
			return false;
		end

		if (dx <= (rw * 0.5)) then
			return true;
		end
		if (dy <= (rh * 0.5)) then
			return true;
		end

		local cornerDistanceSq = (dx - rw * 0.5) * (dx - rw * 0.5) +
				(dy - rh * 0.5) * (dy - rh * 0.5);

		collision = (cornerDistanceSq <= (cr * cr));

		return collision;
	end

	function s.checkColissionPointTriangle(px, py, p1x, p1y, p2x, p2y, p3x, p3y)

		local alpha = ((p2y - p3y) * (px - p3x) + (p3x - p2x) * (py - p3y)) /
				((p2y - p3y) * (p1x - p3x) + (p3x - p2x) * (p1y - p3y));
		local beta = ((p3y - p1y) * (px - p3x) + (p1x - p3x) * (py - p3y)) /
				((p2y - p3y) * (p1x - p3x) + (p3x - p2x) * (p1y - p3y));
		local gamma = 1 - alpha - beta

		return (alpha > 0) and (beta > 0) and (gamma > 0)
	end

	return s
end
