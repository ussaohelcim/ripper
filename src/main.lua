import "CoreLibs/graphics"

import "chell-date"
import "chell-ui"
import "chell-graphics"
import "chell-math"
import "props"
import "player"
import "text-particles"
import "gameMode"


local font = playdate.graphics.font.new("assets/fonts/Asheville-Sans-14-Bold")
playdate.graphics.setFont(font)

local gfx = Graphics()
local m = Math()

function GameScene()
	local s = Scene()

	local gameModes = {
		['Survival'] = Survival,
		['Classic'] = Classic,
		['Arcade'] = Arcade,
		['Crazy'] = Crazy,
		['Weird'] = Weird,
	}
	local _mode = {}

	function s.changeMode(mode)
		ClearProps()
		print(s.getDeltaTime())
		_mode = gameModes[mode]()
		s.start()
	end

	function s.restart()
		ClearProps()
		print(s.getDeltaTime())
		_mode = gameModes[_mode.name]()
		s.start()
	end

	s.update = function(dt)
		_mode.update(dt)
	end

	s.draw = function(dt)
		_mode.draw(dt)
	end


	return s
end

local gameScreen = GameScene()
local mainMenu = Scene()

local list = H_ActionList(
	{

		{
			name = 'Arcade mode',
			helpText = "Timed game (60s). Every hit on dark circles you increase your combo meter and earn 1 point times your combo meter. If you hit a white circle, the combo meter resets.",
			highscore = Highscore('Arcade'),
			action = function()
				gameScreen.changeMode('Arcade')
			end
		},
		{
			name = 'Survival mode',
			helpText = "Infinite game. Try to survive in this game mode. You have a hunger meter, that will increase if you don't hit any circles. You earn points by hitting the dark circles, and lose lifes by hitting the white circles.\n\nBEWARE, YOU HAVE ONLY 5 LIFES!",
			highscore = Highscore('Survival'),
			action = function()
				gameScreen.changeMode('Survival')
			end
		},
		{
			name = 'Classic mode',
			helpText = "The classic ripper game. Timed game (60s). You earn points by slicing dark circles, if you slice a white circle you lose points. If you hit more than 1 dark circle at same time you have a combo.\nIf your highscore is greater than 60, the time will be the same as your highscore.",
			highscore = Highscore('Classic'),
			action = function()
				gameScreen.changeMode('Classic')
			end
		},
		{
			name = 'Crazy mode',
			helpText = "Timed game (60s).\nIn this mode there are only dark circles, you earn points by slicing them, you earn MORE POINTS if the circle is far from the center!",
			highscore = Highscore('Crazy'),
			action = function()
				gameScreen.changeMode('Crazy')
			end
		},
		{
			name = 'Weird mode',
			helpText = "Infinite game.\nIn this BUTTON SMASH mode you earn points by SLICING EMPTY SPACES, but you lose lifes if you hit a circle.You have a hunger meter, that will increase if you don't try to slice.\nBEWARE, YOU HAVE ONLY 10 LIFES! ",
			highscore = Highscore('Weird'),
			action = function()
				gameScreen.changeMode('Weird')
			end
		},
	},
	400, 240
)

list.images = {}
--cache images
for i = 1, #list.list, 1 do
	list.images[i] = gfx.generateImage(function()
		gfx.clear()

		gfx.textCenter(list.list[i].name, 200, 60)
		gfx.textCenter("highscore: " .. list.list[i].highscore.score, 200, 80)

		gfx.textRect(
			list.list[i].helpText,
			10, 100, 380, 140
		)
	end)
end

list.drawCellCallback = function(section, row, column, selected, x, y, width, height)

	gfx.image(list.images[column], x, y)
	gfx.text("left and right - choose game mode.\nA to start!", 10, 5)

end

mainMenu.update = function(dt)
	list.update()
	if playdate.buttonJustPressed 'up' then
		print(collectgarbage('count'), 'Kb')
	end
end

mainMenu.draw = function(dt)
	list.draw(0, 0, 400, 240)
end

mainMenu.start()
local menu = playdate.getSystemMenu()

local menuItem, error = menu:addMenuItem("Main menu", function()
	--gambiarra para refrescar os highscore

	for i = 1, #list.list, 1 do
		local game = list.list[i]
		game.highscore.load()
		list.images[i] = gfx.generateImage(function()
			gfx.clear()

			gfx.textCenter(list.list[i].name, 200, 60)
			gfx.textCenter("highscore: " .. list.list[i].highscore.score, 200, 80)

			gfx.textRect(
				list.list[i].helpText,
				10, 100, 380, 140
			)
		end)
	end
	ClearTextParticles()
	mainMenu.start()
end)

--playtests
--classic 	1
--arcade 		1
--survival 	2
--weird 		1
--crazy 		1
