--The Titular Floppy Bird
Bird = Class{}

local GRAVITY = 5
local ANTIGRAVITY = -10

function Bird:init()
    --load bird image from disk and assign its width and height
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width/2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height/2)

    self.dy = 0

end

function Bird:collides(pipe)
    --the 2's are left and top offsets, the 4's are right and bottom offsets
    --both offsets are used to shrink the bounding box to give the player some leeway

    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt) --called every frame
    self.dy = self.dy + GRAVITY * dt

    --Patented Floppy flying code, love.keyboard.keysPressed and love.keyboard.wasPressed retained for future use
    if love.keyboard.isDown('space') or love.mouse.isDown(1) then 
        self.dy = self.dy + ANTIGRAVITY * dt
    end

    self.y = self.y + self.dy

end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end