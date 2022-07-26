--[[
    The Score State, tells you how good you done did, and gives you a medal
]]

local bronzeMedal = love.graphics.newImage("bronze_medal.png")
local silverMedal = love.graphics.newImage("silver_medal.png")
local goldMedal = love.graphics.newImage("gold_medal.png")

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
        self.awardImage = goldMedal

    elseif self.score >= self.silverScore then
        self.award = 'silver'
        self.awardImage = silverMedal

    elseif self.score >= self.bronzeScore then
        self.award = 'bronze'
        self.awardImage = bronzeMedal

    else
        self.award = 'none'
    end

end



function ScoreState:update(dt)
    --go back to play if 'enter' is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf("Your Rank: ".. self.award, 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score ' .. tostring(self.score), 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 'center')

    if self.awardImage then
        love.graphics.draw(self.awardImage, VIRTUAL_WIDTH / 2 - (self.awardImage:getWidth()) / 2, 
        VIRTUAL_HEIGHT / 2 - (self.awardImage:getHeight()) / 2)
    end


    love.graphics.printf('Press Enter to play again!', 0, VIRTUAL_HEIGHT - 100, VIRTUAL_WIDTH, 'center')
end