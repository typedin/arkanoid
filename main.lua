local Collision = require("collision/collision")
local Config = require("config.config")
local Game = require("entities/game")
local Score = require("entities/score")
local resolutions = require("config.resolutions")

local game

function love.load()
    love.window.setTitle("Arkanoid Clone")
    love.window.setMode(640, 480)

    local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 640, height = 480 } })
    game = Game:new(config)

    game.stateMachine:change("play")
end

function love.update(dt)
    -- first argument received by update is _self_
    game.stateMachine:update(game, { dt = dt, layout = game.config.layout })
    Collision.handle(game)

    if game.level:cleared() then
        game:nextLevel()
    end

    if love.keyboard.isDown("left") then
        if Collision.paddle_left_wall(game) then
            game.paddle.x = game.config.layout.areas.live.x
        else
            game.paddle:moveLeft({ dt = dt })
            game.ball:moveLeft({ dt = dt, layout = game.config.layout, paddle = game.paddle })
        end
    end

    if love.keyboard.isDown("right") then
        if Collision.paddle_right_wall(game) then
            game.paddle.x = game.config.layout.areas.live.width + game.config.layout.areas.live.x - game.paddle.width
        else
            game.paddle:moveRight({ dt = dt })
            game.ball:moveRight({ dt = dt, layout = game.config.layout, paddle = game.paddle })
        end
    end

    if love.keyboard.isDown("space") then
        game.ball.glued = false
    end

    if love.keyboard.isDown("p") then
        game.stateMachine:change("pause")
    elseif love.keyboard.isDown("r") then
        game.stateMachine:change("resume")
    end
end

function love.draw()
    for _, wall in ipairs(game.walls) do
        wall:draw()
    end
    -- Draw bricks
    for _, brick in ipairs(game.level.bricks) do
        if brick.hits > 0 then
            brick:draw()
        end
    end

    game.paddle:draw()
    game.ball:draw()

    -- Draw Lives
    for _, life in ipairs(game.lives) do
        life:draw()
    end

    local score_table = Score:toTable(game.score)
    for i = 1, #score_table do
        love.graphics.print(
            score_table[i],
            game.config.layout.areas.hud.x + game.config.layout.areas.hud.width / 2 + (10 * i),
            game.config.layout.areas.hud.y + game.config.layout.areas.hud.height / 2
        )
    end
end
