local layout = require("config/main").layout
local Ball = require("entities/ball")
local Paddle = require("entities/paddle")

local Collision = {}

function Collision.handle(game)
    Collision.ball_paddle(game)
    Collision.ball_fell(game)
    Collision.ball_bricks(game)
    Collision.ball_walls(game)
end

function Collision.ball_walls(game)
    local ball = game.ball
    if ball.x + ball.radius / 2 > game.layout.wall_right.x - game.layout.wall_right.thickness then
        ball:invert("dx")
    end
    if ball.x - ball.radius / 2 < game.layout.wall_left.x + game.layout.wall_left.thickness then
        ball:invert("dx")
    end
    if ball.y + ball.radius / 2 < game.layout.wall_up.y + game.layout.wall_up.thickness then
        ball:invert("dy")
    end
end

function Collision.ball_paddle(game)
    local ball = game.ball
    local paddle = game.paddle

    if ball.y + ball.radius > paddle.y and ball.x > paddle.x and ball.x < paddle.x + paddle.width then
        ball.dy = -math.abs(ball.dy)

        local hit_pos = (ball.x - paddle.x) / paddle.width
        ball.dx = (hit_pos - 0.5) * 400
    end
end

function Collision.ball_fell(game)
    local ball = game.ball
    local paddle = game.paddle

    if ball.y > paddle.y + paddle.height then
        game.lives = game.lives - 1
        game.paddle = Paddle:new()
        game.ball = Ball:new()

        if game.lives == 0 then
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
            and ball.x + ball.radius > brick.x
            and ball.x - ball.radius < brick.x + brick.width
            and ball.y + ball.radius > brick.y
            and ball.y - ball.radius < brick.y + brick.height
        then
            brick.hits = brick.hits - 1
            if brick.hits < 1 then
                game.score = game.score + layout.bricks.kinds[brick.kind].points
            end
            ball.dy = -ball.dy
        end
    end
end

return Collision
