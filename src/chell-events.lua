function EventManager()
	local s = {}

	local events = {}
	local loopedEvents = {}

	local function eventObjectPooling(time, callback, loop)
		local found = false

		for i = 1, #events, 1 do
			local e = events[i]

			if e.ttl <= 0 then
				e.ttl = time
				e.maxttl = time
				e.callback = callback

				found = true

			end
		end

		if not found then
			events[#events + 1] = {
				ttl = time,
				maxttl = time,
				callback = callback,
			}
		end

	end

	---comment
	---@param time number
	---@param callback function
	function s.addOneshotEvent(time, callback)

		eventObjectPooling(time, callback)
	end

	---comment
	---@param time number
	---@param callback function
	function s.addLoopEvent(time, callback)
		loopedEvents[#loopedEvents + 1] = {
			ttl = time,
			maxttl = time,
			callback = callback,
		}
		-- eventLoopObjectPooling(time, callback)
	end

	function s.update(dt)
		for i = 1, #events, 1 do
			local event = events[i]
			if event.ttl > 0 then
				event.ttl = event.ttl - dt
				if event.ttl <= 0 then
					event.callback()
				end
			end
		end
		for i = 1, #loopedEvents, 1 do
			local event = loopedEvents[i]
			if event.ttl > 0 then
				event.ttl = event.ttl - dt
				if event.ttl <= 0 then
					event.callback()
					event.ttl = event.maxttl
				end
			end
		end

	end

	return s
end
