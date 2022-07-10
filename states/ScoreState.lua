--[[
    The Score State, Getting to this
]]
ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state we expect to receive the score so we know what to render
]]

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    --go back to play if 'enter' is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf("Ouch! You lost!", 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to play again!', 0, 160, VIRTUAL_WIDTH, 'center')
end