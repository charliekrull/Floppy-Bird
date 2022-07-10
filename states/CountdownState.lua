--[[
    Countdown before tossing the user in head first
]]

CountdownState = Class{__includes = BaseState}

--takes a second to count down each time. original had COUNTDOWN_TIME = 0.75. And it is better
COUNTDOWN_TIME = 0.75

function CountdownState: init()
    self.count = 3
    self.timer = 0
end

--[[
    Keeps track of how much time has passed and decreases count if the timer has exceeded
    our countdown time. If countdown hits 0, go to PlayState
]]

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end