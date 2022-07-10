--[[
    The PlayState is the bulk of the game, where the player actually controls the little bird thing.
    When the player collides with a pipe we should update this comment

]]
PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    --initiliaze our last recorded Y value for gap placement
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    --update timer for pipe spawning
    self.timer = self.timer + dt

    --spawn a new pipe pair every second and a half

    if self.timer > 1.5 then
        --modify the last Y coordinate we placed so pipe gaps aren't impossible
        --no higher than 10 pixels below top edge of screen,
        --no lower than 90 pixels from the bottom
        local y = math.max(-PIPE_HEIGHT + 10,
        math.min(self.lastY + math.random(-20, 20, VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT)))
        self.lastY = y

        --add a new pipe pair at the end of the screen at our
        table.insert(self.pipePairs, PipePair(y))

        --reset timer
        self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do
        --score a point if its right edge is beyond the bird's left edge
        --ignore if already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
            end
        end

        pair:update(dt)
    end

    --remove any flagged pipes
    --we need this second loop because modifying the table in place would cause skipping pipePairs
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    self.bird:update(dt)

    --simple collision between bird andall pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end
    --reset if bird hits the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('score', {
            score = self.score
        })
    end

end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end

function PlayState:enter()
    scrolling = true
end

function PlayState:exit()
    scrolling = false
end