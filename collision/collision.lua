local Ball = require("entities/ball")
local Paddle = require("entities/paddle")

local Collision = {}

function Collision.handle(game)
    Collision.ball_fell(game)
    Collision.ball_bricks(game)
end

function Collision.paddle_left_wall(game)
    if game.paddle:getGeometry().left <= game.walls.left:getGeometry().right then
        return true
    end
    return false
end

function Collision.paddle_right_wall(game)
    if game.paddle:getGeometry().right >= game.walls.right:getGeometry().left then
        return true
    end
    return false
end

function Collision.ball_left_wall(game)
    if game.ball:getGeometry().left <= game.walls.left:getGeometry().right then
        return true
    end
    return false
end

function Collision.ball_right_wall(game)
    if game.ball:getGeometry().right >= game.walls.right:getGeometry().left then
        return true
    end
    return false
end

function Collision.ball_top_wall(game, dt)
    if game.ball:getGeometry().top + dt < game.walls.top:getGeometry().bottom then
        return true
    end
    return false
end

function Collision.ball_paddle(game)
    if
        game.ball:getGeometry().bottom <= game.paddle:getGeometry().top
        and game.ball:getGeometry().center >= game.paddle:getGeometry().left
        and game.ball:getGeometry().center <= game.paddle:getGeometry().right
    then
        return true
    end
    return false
end

function Collision.ball_fell(game)
    local ball = game.ball
    local paddle = game.paddle

    if ball.y > paddle.y + paddle.height then
        table.remove(game.lives)
        game.paddle = Paddle:new({
            paddle = game.layout.paddle,
            live_area = game.layout.areas.live,
            physics = require("config.physics.entities").paddle,
        })
        game.ball = Ball:new({
            ball = game.layout.ball,
            live_area = game.layout.areas.live,
            physics = require("config.physics.entities").ball,
        })
        if #game.lives == 0 then
            love.event.quit(0)
        end
    end
end

function Collision.ball_bricks(game)
    local ball = game.ball
    local bricks = game.level.bricks

    for _, brick in ipairs(bricks) do
        if
            brick.hits > 0
            and ball.x + ball.diameter / 2 > brick.x
            and ball.x - ball.diameter / 2 < brick.x + brick.width
            and ball.y + ball.diameter / 2 > brick.y
            and ball.y - ball.diameter / 2 < brick.y + brick.height
        then
            brick.hits = brick.hits - 1
            if brick.hits < 1 then
                game.players[1].score:add(brick.points)
            end
            ball.dy = -ball.dy
        end
    end
end

return Collision
