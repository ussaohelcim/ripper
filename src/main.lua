import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "highscore"
import "game"

import "UI"

local gameOverScreen = GameOverScreen
local gfx = playdate.graphics

GAME = Game()

local function newGame()
	GetDeltaTime() --RESETS THE TIMER
	GAME.newMatch(60, 4)
	playdate.update = GAME.update

end

local menu = playdate.getSystemMenu()

local menuItem, error = menu:addMenuItem("New game", function()
	newGame()
end)
local highfps = false

local m, e = menu:addCheckmarkMenuItem("50 FPS", highfps, function()
	highfps = not highfps
	playdate.display.setRefreshRate(
		math.iff(highfps, 50, 30)
	)
end)

local font = playdate.graphics.font.new("assets/fonts/Asheville-Sans-14-Bold")
playdate.graphics.setFont(font)

function GameOverScreen()
	gfx.clear()
	gfx.drawText("score: " .. GAME.score, 0, 0)

	if GAME.score >= GAME.scoreboard.highscore.score and not (GAME.score == 0) then
		gfx.drawText("NEW HIGHSCORE!", 0, 40)
	end

	gfx.drawText("highscore: " .. GAME.scoreboard.highscore.score, 0, 20)

	-- gfx.drawText("Press MENU to start a new game!", 100, 120)
	gfx.drawTextAligned("Press MENU to start a new game!", 200, 120, kTextAlignment.center)
end

playdate.update = GameOverScreen

--TODO usar funcoes locais todo onde
