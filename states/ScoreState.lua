--[[
    The Score State, tells you how good you done did, and gives you a medal
]]

local cup_bronze = love.graphics.newImage("cup_bronze.png")
local cup_silver = love.graphics.newImage("cup_silver.png")
local cup_gold = love.graphics.newImage("cup_gold.png")

ScoreState = Class{__includes = BaseState}


--[[
    When we enter the score state we expect to receive the score so we know what to render
]]

function ScoreState:enter(params)
    self.score = params.score
    self.bronzeScore = 5
    self.silverScore = 7
    self.goldScore = 9
    if self.score >= self.goldScore then
        self.award = 'gold'
        self.awardImage = cup_gold

    elseif self.score >= self.silverScore then
        self.award = 'silver'
        self.awardImage = cup_silver

    elseif self.score >= self.bronzeScore then
        self.award = 'bronze'
        self.awardImage = cup_bronze

    else
        self.award = 'none'
    end

end



function ScoreState:update(dt)
    --go back to play if 'enter' is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf("Your Rank: ".. self.award, 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score ' .. tostring(self.score), 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 'center')

    if self.awardImage then
        love.graphics.draw(self.awardImage, VIRTUAL_WIDTH / 2 - (self.awardImage:getWidth() * 4) / 2, 
        VIRTUAL_HEIGHT / 2 - (self.awardImage:getHeight() * 4) / 2, 0, 4, 4)
    end


    love.graphics.printf('Press Enter to play again!', 0, VIRTUAL_HEIGHT - 100, VIRTUAL_WIDTH, 'center')
end