local cos = math.cos
local sin = math.sin
local sqrt = math.sqrt
local abs = math.abs
---Check if a number is between [min,max].
---min <= value <= max
---@param value any
---@param min any
---@param max any
---@return boolean
function math.isInBetween(value, min, max)
	return value >= min and value <= max
end

function math.AngleToNormalizedVector(angle, out)
	out.x = cos(angle)
	out.y = sin(angle)
end

function math.lerp(a, b, w)
	return a + w * (b - a);
end

---comment
---@param ox any
---@param oy any
---@param x any
---@param y any
function math.distance(ox, oy, x, y)
	return sqrt((ox - x) * (ox - x) + (oy - y) * (oy - y))
end

function math.remap(v, old_min, old_max, new_min, new_max)
	return ((v - old_min) / (old_max - old_min)) * (new_max - new_min) + new_min
end

math.magnitude = math.distance
math.length = math.distance

---Returns a number that simbolizes a distance. This is great for stuff like comparing distances. It DOESNT return the actual distance.
---@param ox number origin x
---@param oy number origin y
---@param x number target x
---@param y number target y
---@return number
function math.squareDistance(ox, oy, x, y)
	return (ox - x) * (ox - x) + (oy - y) * (oy - y)
end

math.squareLength = math.squareDistance
math.squareMagnitude = math.squareDistance

function math.checkCollisionPointLine(px, py, x, y, xx, yy)
	local d1 = sqrt((px - x) * (px - x) + (py - y) * (py - y)) -- distancia do ponto para ponta[0] da linha
	local d2 = sqrt((px - xx) * (px - xx) + (py - yy) * (py - yy))
	local lineLen = math.distance(x, y, xx, yy) --transforma a linha em apenas 1d

	return math.isInBetween(d1 + d2, 0, lineLen) --d1 + d2 >= lineLen and d1 + d2 <= lineLen
end

-- function math.fastCheckCollisionPointLine(px, py, x, y, xx, yy)
-- 	--FIXME
-- 	local d1 = math.squareDistance(px, py, x, y)
-- 	local d2 = math.squareDistance(px, py, xx, yy)
-- 	local lineLen = math.squareDistance(x, y, xx, yy)

-- 	return math.isInBetween(d1 + d2, 0, lineLen)
-- 	-- return value >= min and value <= max
-- end


function math.checkCollisionLineCircle(x1, y1, x2, y2, cx, cy, cr)
	--FIXME só funciona em linhas "infinitas"

	--agora vou pegar o ponto mais proximo entre a linha e o circulo
	--como temos uma linha e um ponto (circulo) podemos formar um triangulo, que no momento não é um triangulo retangulo
	--essa linha pode ser transformada em um vetor, para fazer isso devemos fazer uma transformação e colocar o x,y da linha na origin 0,0, para fazer isso basta subtrair as pontas

	local dx, dy = x1 - x2, y1 - y2
	local length = sqrt(dx * dx + dy * dy) --teorema de pitagoras para descobrir o tamanho da hipotenusa, que no caso é o mesmo que o length ou magnitude de um vetor

	--agora calculamos o dot product entre a linha e o circulo
	--TODO explicar porque usar o dot product

	local dot = (((cx - x1) * (x2 - x1)) + ((cy - y1) * (y2 - y1))) / (length * length)

	--agora devemos calcular o ponto mais proximo na linha entre a linha e o ponto

	local closestX = x1 + (dot * (x2 - x1));
	local closestY = y1 + (dot * (y2 - y1));

	-- playdate.graphics.drawLine(closestX, closestY, cx, cy)

	--distancia entre o ponto mais proximo e o circulo
	dx = closestX - cx
	dy = closestY - cy

	local distance = sqrt(dx * dx + dy * dy)

	if distance <= cr then
		return true
	end

	return false
end

function math.iff(comparisonResult, iftrue, iffalse)
	return comparisonResult and iftrue or iffalse
end

-- function CircleLine(x, y, r, p1x, p1y, p2x, p2y)
-- 	p1x = p1x - x
-- 	p1y = p1y - y
-- 	p2x = p2x - x
-- 	p2y = p2y - y

-- 	local dx = p2x - p1x
-- 	local dy = p2y - p1y
-- 	local dr = sqrt(dx * dx + dy * dy)
-- 	local d = p1x * p2y - p2x * p1x
-- 	local di = (r * r) * (dr * dr) - (d * d)

-- 	return not di < 0
-- end

function math.CheckCollisionCircles(x1, y1, r1, x2, y2, r2)
	local collision = false;

	local dx = x2 - x1;
	local dy = y2 - y1;

	local distance = sqrt(dx * dx + dy * dy);

	if (distance <= (r1 + r2)) then
		collision = true;
	end

	return collision;
end

function math.CheckCollisionCircleRect(cx, cy, cr, rx, ry, rw, rh)
	local collision = false

	local recCenterX = (rx + rw / 2);
	local recCenterY = (ry + rh / 2);

	local dx = abs(cx - recCenterX);
	local dy = abs(cy - recCenterY);

	if (dx > (rw / 2 + cr)) then
		return false
	end

	if (dy > (rh / 2 + cr)) then
		return false
	end

	if (dx <= (rw / 2)) then
		return true
	end
	if (dy <= (rh / 2)) then
		return true
	end

	local cornerDistanceSq = (dx - rw / 2) * (dx - rw / 2) +
			(dy - rh / 2) * (dy - rh / 2);

	collision = (cornerDistanceSq <= (cr * cr));

	return collision;
end

math.TAU = math.pi * 2
