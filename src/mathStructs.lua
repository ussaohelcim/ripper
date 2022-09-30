-- function Float(n)
-- 	local self = {}
-- 	local x = n

-- 	local meta = {
-- 		__tostring = function()
-- 			return x
-- 		end
-- 	}

-- 	setmetatable(self, meta)



-- 	return self
-- end

-- function Vec2(x, y)
-- 	local self = Float(x)

-- 	local meta = {
-- 		__tostring = function()
-- 			return "(" .. x .. " , " .. y .. ")"
-- 		end
-- 	}

-- 	setmetatable(self, meta)



-- 	return self
-- end

-- function Vec3(x, y, z)
-- 	local self = Vec2(x, y)

-- 	local meta = {
-- 		__tostring = function()
-- 			return "(" .. x .. " , " .. y .. " , " .. z .. ")"
-- 		end
-- 	}

-- 	setmetatable(self, meta)



-- 	return self
-- end

-- function Vec4(x, y, z, w)
-- 	local self = Vec3(x, y, z)

-- 	local meta = {
-- 		__tostring = function()
-- 			return "(" .. x .. " , " .. y .. " , " .. z .. " , " .. w .. ")"
-- 		end
-- 	}

-- 	setmetatable(self, meta)

-- 	return self
-- end
