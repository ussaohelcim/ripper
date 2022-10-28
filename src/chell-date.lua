import "CoreLibs/graphics"

local screenW = 400
local screenH = 240

local timeDT = playdate.getCurrentTimeMilliseconds
local _lastDT = timeDT()
local getButtonState = playdate.getButtonState

local _timeScale = 1

function SetTimeScale(v)
	_timeScale = v
end

function Scene()
	local self = {}
	_lastDT = timeDT()

	function self.getDeltaTime()
		return timeDT() - _lastDT
	end

	local function _Update()
		local now = timeDT()
		local dt = now - _lastDT
		_lastDT = now

		self.update((dt * 0.001) * _timeScale)
		self.draw((dt * 0.001) * _timeScale)
	end

	---Start this scene. This replace the playdate.update to this scene.
	function self.start()
		playdate.update = _Update
	end

	---Draw callback, called every frame
	---@param dt number time since last engine update in seconds
	function self.draw(dt) end

	---Update callback, called every frame
	---@param dt number time since last engine update in seconds
	function self.update(dt) end

	return self
end

function Highscore(filename)
	local s = {}
	local d = playdate.datastore.read(filename) or { score = 0 }
	s.score = d.score

	print("loaded", filename, s.score)

	local function save()
		print("saved at", filename)
		playdate.datastore.write({ score = s.score }, filename)
	end

	function s.addScore(score)
		if score > s.score then
			s.score = score
			save()
		end
	end

	function s.load()
		local dd = playdate.datastore.read(filename) or { score = 0 }
		s.score = dd.score
	end

	return s
end

function MemoryCard(filename)
	local s = {}
	s.data = {}
	local file = filename

	local function save()
		playdate.datastore.write(s.score, file)
	end

	function s.load()
		s.data = playdate.datastore.read(file)
	end

	function s.overwrite(data)
		s.data = data
		save()
	end

	return s
end
