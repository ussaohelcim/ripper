-- -- Newton's Laws of Motion:
-- -- - An objects velocity will not change unless affected by an external force
-- -- - The acceleration of an object is proportional to the magnitude of the force acting on the object, and inversely proportional to the mass of the object
-- -- F = M * A (forca = massa * aceleracao)
-- -- A = F / M (aceleracao = forca / massa)
-- -- V' = V + A * dt (nova velocidade = velocidade + aceleracao * tempo)
-- -- P' = P + V * dt (nova posicao = posicao + velocidade * tempo)
-- -- - Every action has an equal and opposite reaction

-- local gx, gy = 0, -9.8

-- function RigidBody()
-- 	local s = {}

-- 	function s.update(dt)
-- 	end

-- 	---sum all forces acting on this body
-- 	function s.applyForces()

-- 	end

-- 	---Every action has an equal and opposite reaction
-- 	---@param constraints table
-- 	function s.solveConstraints(constraints)

-- 	end

-- 	function s.debugDraw()

-- 	end

-- 	return s
-- end

-- function PhysicsSystem()
-- 	local s = {}
-- 	local bodies = {}
-- 	local constraints = {}

-- 	function s.update(dt)
-- 		for i = 1, #bodies, 1 do
-- 			bodies[i].applyForces()
-- 			bodies[i].update(dt)
-- 			bodies[i].solveConstraints(constraints)
-- 		end
-- 	end

-- 	function s.addRigidBody(body)
-- 		bodies[#bodies + 1] = body
-- 	end

-- 	function s.addConstaint(constraint)
-- 		constraint[#constraint + 1] = constraint
-- 	end

-- 	function s.clearRigidBodys()
-- 		bodies = {}
-- 	end

-- 	function s.debugDraw()

-- 	end

-- 	return s
-- end

-- local function vec2mul(x, y, a)
-- 	return x * a, y * a
-- end

-- function Particle()
-- 	local s = RigidBody()
-- 	local _x, _y, oldX, oldY = 0, 0, 0, 0
-- 	local fx, fy, vx, vy = 0, 0, 0, 0 --force, velocity

-- 	local mass = 1
-- 	-- Coefficient of Restitution.   In simple terms, this value represents how much energy is kept when a particle bounces off a surface. The value of this variable should be within the range of 0 to 1
-- 	local bounce = 0.7

-- 	local friction = 0.95

-- 	function s.setPosition(x, y)
-- 		_x, _y, oldX, oldY = x, y, x, y
-- 	end

-- 	function s.setBounce(b)
-- 		bounce = b
-- 	end

-- 	function s.getPosition()
-- 		return _x, _y
-- 	end

-- 	s.solveConstraints = function(constraints)
-- 		for i = 1, #constraints, 1 do

-- 			-- if colisaoLinha(constraints[i], linha(posicaoVelha, novaPosicao)) then

-- 			-- end
-- 		end
-- 	end

-- 	s.applyForces = function()
-- 		fx, fy = gx, gy
-- 	end

-- 	s.update = function(dt)
-- 		oldX, oldY = _x, _y
-- 		-- local ax, ay = fx * (1.0 / mass), fy * (1.0 / mass)
-- 		local ax, ay = vec2mul(fx, fy, (1.0 / mass))

-- 		--velocity * friction + acceleration * dt
-- 		vx, vy = vx * fx + ax * dt, vy * fy + ay * dt

-- 		--euler integration
-- 		--position + velocity * dt
-- 		-- _x, _y = _x + vx * dt, _y + vy * dt

-- 		-- Velocity Verlet Integration
-- 		-- P = (( V old + V) / 2) * dt (posicao = (velocidade antiga + velocidade / 2) * tempo )
-- 		--position + (oldVelocity + velocity) * 0.5f * deltaTime;
-- 		_x, _y = _x + (oldX + vx) * 0.5 * dt, _y + (oldY + vy) * 0.5 * dt
-- 	end

-- 	return s
-- end
