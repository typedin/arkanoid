local Ball = require("entities/ball")
local Brick = require("entities/brick")
local Collision = require("collision/Collision")
local Game = require("entities/game")
local Paddle = require("entities/paddle")
local Score = require("entities/score")
local StateMachine = require("states/StateMachine")
local ball_states = require("states/ball_states")
local game_states = require("states/game_states")
local layout = require("config/main").layout
local paddle_states = require("states/paddle_states")

local game

-- don't load all levels at once for memory reasons
local level = require("levels/" .. 1)

--- Calculates the width of a single brick based on the live area, spacing, and brick count.
---@param areaWidth number - total usable width for all bricks (no padding on sides)
---@param spacing number - space between adjacent bricks
---@param brickCount integer - max number of bricks per row
---@return number - width of a single brick
local calculateBrickWidth = function(areaWidth, spacing, brickCount)
    if brickCount < 1 then
        return 0
    end

    local totalSpacing = (brickCount - 1) * spacing
    local availableWidth = areaWidth - totalSpacing
    return availableWidth / brickCount
end

local brickWidth = calculateBrickWidth(layout.area.live.width - layout.wall.thickness * 2, layout.bricks.margin, 13)

function love.load()
    love.window.setTitle("Arkanoid Clone")
    love.window.setMode(layout.resolution.width, layout.resolution.height)
    game = Game:new()
    game.paddle = Paddle:new()
    game.ball = Ball:new()

    -- WARNING:
    -- paddle.stateMachine.currentState will be {}
    -- don't move this to the "constructor" function
    -- keep it YAGNI
    game.paddle.stateMachine = StateMachine:new(paddle_states)
    game.ball.stateMachine = StateMachine:new(ball_states)
    game.stateMachine = StateMachine:new(game_states)
    game.ball.stateMachine:change("moving")
    game.bricks = {}
    game.lives = 3
    game.score = 0

    game.stateMachine:change("play")

    -- Initialize bricks
    -- iterate over rows
    for i, row in ipairs(level.rows) do
        for j, brick in ipairs(row) do
            -- IMPORTANT:
            -- Keep brickWidth out of Brick
            local x = (j - 1) * (brickWidth + layout.bricks.margin) + layout.wall_left.x + layout.wall_left.thickness
            local y = i * (layout.bricks.height + layout.bricks.margin) + layout.wall_up.thickness
            table.insert(
                game.bricks,
                Brick:new({
                    x = x,
                    y = y,
                    kind = brick.kind,
                    width = brickWidth,
                    height = layout.bricks.height,
                })
            )
        end
    end
end

function love.update(dt)
    -- first argument received by update is _self_
    game.stateMachine:update(game, { dt = dt, layout = layout })
    Collision.handle(game)

    -- Paddle movement
    if love.keyboard.isDown("left") then
        game.paddle.stateMachine:change("moving_left")
    elseif love.keyboard.isDown("right") then
        game.paddle.stateMachine:change("moving_right")
    else
        game.paddle.stateMachine:change("idle")
    end

    if love.keyboard.isDown("p") then
        game.stateMachine:change("pause")
    elseif love.keyboard.isDown("r") then
        game.stateMachine:change("resume")
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", layout.wall_left.x, layout.wall_left.y, layout.wall_left.width + layout.wall_left.thickness, layout.wall_left.height)
    love.graphics.rectangle("fill", layout.wall_up.x, layout.wall_up.y, layout.wall_up.width, layout.wall_up.height + layout.wall_left.thickness)
    love.graphics.rectangle("fill", layout.wall_right.x, layout.wall_right.y, layout.wall_right.width + layout.wall_left.thickness, layout.wall_right.height)

    -- Draw bricks
    for _, brick in ipairs(game.bricks) do
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
