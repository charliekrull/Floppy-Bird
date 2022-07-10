--based on Colton Ogden's lessons

--used to represent a pair of pipes that stick together as they scroll so there are gaps to aim for

PipePair = Class{}

local GAP_HEIGHT = 120

function PipePair:init(y)
    --initialize pipes past the end of the screen
    self.x = VIRTUAL_WIDTH

    --y valuse if for the topmost pipe; gap is a vertical shift of the second pipe
    self.y = y

    --instantiate 2 pipes that belong to this pair
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
    --whether this pair can be removed from the scene
    self.remove = false

    --whether or not this pair of pipes has been scored 
    self.scored = false
end

function PipePair:update(dt)
    --remove the pipe from the scene if it's beyond the left edge of the screen
    --else, scroll it left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x

    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()

    end
end