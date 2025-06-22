local Collision = require("collision/collision")
local Config = require("config.config")
local Game = require("entities/game")
local Score = require("entities/score")
local resolutions = require("config.resolutions")

local game

function love.load()
    love.window.setTitle("Arkanoid Clone")
    love.window.setMode(640, 480)

    local config = Config:new({ players = {}, resolution = resolutions["amiga"], screen = { width = 640, height = 480 } })
    game = Game:new(config)

    game.stateMachine:change("play")
end

function love.update(dt)
    -- first argument received by update is _self_
    game.stateMachine:update(game, dt)
    Collision.handle(game)

    if game.level:cleared() then
        game:nextLevel()
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
    -- key value pairs
    for _, wall in pairs(game.walls) do
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
