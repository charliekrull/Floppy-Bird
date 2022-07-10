--A Flappy Bird clone done to the tune of Harvard's CS50 game design course. Requires LOVE2D
--https://opengameart.org/content/5-chiptunes-action background music source: Subspace Audio

push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/CountdownState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


--load images

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 65

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = VIRTUAL_WIDTH



local bird = Bird()

local pipePairs = {}

local spawnTimer = 0

--last recorded Y value for a gap placement to base other gaps on
local lastY = -PIPE_HEIGHT + math.random(80) + 20

--scrolling variable to pause the game when we collide with a pipe
local scrolling = true

--runs when game starts 
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Floppy Bird')

    --initiliaze what allege to be nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)

    love.graphics.setFont(flappyFont)

    --initialize table of sounds
    sounds = {
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        ['music'] = love.audio.newSource('bg_music.wav', 'static') --https://opengameart.org/content/5-chiptunes-action
    }

    --begin the music
    sounds['music']:setLooping(true)
    sounds['music']:play()


    --seed RNGesus
    math.randomseed(os.time())

    --initilialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --initiliaze state machine with all state-returning functions
    gStateMachine = StateMachine{
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end

    }
    gStateMachine:change('title')

    --initiliaze input table
    love.keyboard.keysPressed = {}
end

--defer resizing to push
function love.resize(w, h)
    push:resize(w, h)
end

--check for user input
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--runs every frame
function love.update(dt)
    --update background and ground scroll offsets
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    --update state machine, which defers to the right state
    gStateMachine:update(dt)

    --reset input table
    love.keyboard.keysPressed = {}
end

--render to screen

function love.draw()
    push:start() --start rendering at virtual resolution

    love.graphics.draw(background, -backgroundScroll, 0) -- draw background

    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16) --draw ground


    push:finish() -- stop rendering at virtual resolution
end