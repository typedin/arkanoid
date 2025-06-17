local Collision = require("collision/collision")
local Game = require("entities/game")
local Score = require("entities/score")
local layout = require("config/main").layout

local game

function love.load()
    love.window.setTitle("Arkanoid Clone")
    love.window.setMode(layout.resolution.width, layout.resolution.height)
    game = Game:new()

    game.stateMachine:change("play")
end

function love.update(dt)
    -- first argument received by update is _self_
    game.stateMachine:update(game, { dt = dt, layout = layout })
    Collision.handle(game)

    if game.level:cleared() then
        game.level:nextLevel()
    end

    -- Paddle movement
    -- Ball movement if it's glued
    if love.keyboard.isDown("left") then
        game.ball:moveLeft({ dt = dt, layout = layout, speed = game.paddle.speed })
        game.paddle.stateMachine:change("moving_left")
    elseif love.keyboard.isDown("right") then
        game.ball:moveRight({ dt = dt, layout = layout, speed = game.paddle.speed })
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
    love.graphics.rectangle("fill", layout.wall_left.x, layout.wall_left.y, layout.wall_left.width + layout.wall.thickness, layout.wall_left.height)
    love.graphics.rectangle("fill", layout.wall_up.x, layout.wall_up.y, layout.wall_up.width, layout.wall_up.height + layout.wall.thickness)
    love.graphics.rectangle("fill", layout.wall_right.x, layout.wall_right.y, layout.wall_right.width + layout.wall.thickness, layout.wall_right.height)

    -- Draw bricks
    for _, brick in ipairs(game.level.bricks) do
        if brick.hits > 0 then
            brick:draw()
        end
    end

    game.paddle:draw()
    game.ball:draw()
    -- Draw Lives
    for i = 1, game.lives do
        love.graphics.setColor(0, 1, 0)
        -- pox_x, pox_y, width, height
        love.graphics.rectangle("fill", layout.live.pos_x + (i - 1) * layout.live.margin_right, layout.live.pos_y, layout.live.width, layout.live.height)
    end

    local score_table = Score:toTable(game.score)
    for i = 1, #score_table do
        love.graphics.print(score_table[i], layout.area.hud.x + layout.area.hud.width / 2 + (10 * i), layout.area.hud.y + layout.area.hud.height / 2)
    end
end
