local layout = require("config/main").layout
local Ball = require("entities/ball")
local Paddle = require("entities/paddle")

local Collision = {}

function Collision.handle(game)
    Collision.ball_paddle(game)
    Collision.ball_fell(game)
    Collision.ball_bricks(game)
    Collision.ball_walls(game)
    Collision.paddle_walls(game)
end

function Collision.paddle_walls(game)
    if game.paddle.x < game.config.layout.areas.live.x + game.config.layout.wall.thickness then
        game.paddle.x = game.config.layout.areas.live.x + game.config.layout.wall.thickness
    end
    if game.paddle.x + game.paddle.width > game.config.layout.areas.live.width - game.config.layout.wall.thickness then
        game.paddle.x = game.config.layout.areas.live.width - game.config.layout.wall.thickness - game.paddle.width
    end
end

function Collision.ball_walls(game)
    local ball = game.ball
    if ball.x + ball.diameter / 2 / 2 > game.config.layout.areas.walls.right.x - game.config.layout.wall.thickness then
        ball:invert("dx")
    end
    if ball.x - ball.diameter / 2 / 2 < game.config.layout.areas.walls.left.x + game.config.layout.wall.thickness then
        ball:invert("dx")
    end
    if ball.y + ball.diameter / 2 / 2 < game.config.layout.areas.walls.top.y + game.config.layout.wall.thickness then
        ball:invert("dy")
    end
end

function Collision.ball_paddle(game)
    local ball = game.ball
    local paddle = game.paddle

    if ball.y + ball.diameter / 2 > paddle.y and ball.x > paddle.x and ball.x < paddle.x + paddle.width then
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
        game.paddle = Paddle:new(game.config)
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
            and ball.x + ball.diameter / 2 > brick.x
            and ball.x - ball.diameter / 2 < brick.x + brick.width
            and ball.y + ball.diameter / 2 > brick.y
            and ball.y - ball.diameter / 2 < brick.y + brick.height
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
