local Collision = require("collision/collision")
local Game = require("entities/game")
local Score = require("entities/score")
local Config = require("config.config")
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
        game.level:nextLevel()
    end

    -- Paddle movement
    -- Ball movement if it's glued
    if
        love.keyboard.isDown("left") --[[ ???? and not collison ?????]]
    then
        game.ball:moveLeft({ dt = dt, layout = game.config.layout, speed = game.paddle.speed })
        game.paddle.stateMachine:change("moving_left")
    elseif love.keyboard.isDown("right") then
        game.ball:moveRight({ dt = dt, layout = game.config.layout, speed = game.paddle.speed })
        game.paddle.stateMachine:change("moving_right")
    else
        game.paddle.stateMachine:change("idle")
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
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle(
        "fill",
        game.config.layout.areas.walls.left.x,
        game.config.layout.areas.walls.left.y,
        game.config.layout.areas.walls.left.width,
        game.config.layout.areas.walls.left.height
    )
    love.graphics.rectangle(
        "fill",
        game.config.layout.areas.walls.top.x,
        game.config.layout.areas.walls.top.y,
        game.config.layout.areas.walls.top.width,
        game.config.layout.areas.walls.top.height
    )
    love.graphics.rectangle(
        "fill",
        game.config.layout.areas.walls.right.x,
        game.config.layout.areas.walls.right.y,
        game.config.layout.areas.walls.right.width,
        game.config.layout.areas.walls.right.height
    )

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
