local paddle = require("config/main").paddle
local ball = require("config/main").ball
local layout = require("config/main").layout

local bricks = {}
local level = require("levels/" .. 1)
function love.load()
    love.window.setTitle("Arkanoid Clone")
    love.window.setMode(800, 600)

    -- Initialize bricks
    for row = 1, layout.bricks.rows do
        for col = 1, layout.bricks.cols do
            table.insert(bricks, {
                x = (col - 1) * (layout.bricks.width + layout.bricks.margin) + 60,
                y = row * (layout.bricks.height + layout.bricks.margin),
                width = layout.bricks.width,
                height = layout.bricks.height,
                alive = true,
                hits = level.bricks[row][col].hits,
            })
        end
    end
end

function love.update(dt)
    -- Paddle movement
    if love.keyboard.isDown("left") then
        paddle.x = paddle.x - paddle.speed * dt
    elseif love.keyboard.isDown("right") then
        paddle.x = paddle.x + paddle.speed * dt
    end

    -- Clamp paddle
    paddle.x = math.max(0, math.min(paddle.x, love.graphics.getWidth() - paddle.width))

    -- Ball movement
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    -- Ball collision with walls
    if ball.x < 0 or ball.x > love.graphics.getWidth() then
        ball.dx = -ball.dx
    end
    if ball.y < 0 then
        ball.dy = -ball.dy
    end

    -- Ball collision with paddle
    if ball.y + ball.radius > paddle.y and ball.x > paddle.x and ball.x < paddle.x + paddle.width then
        ball.dy = -math.abs(ball.dy)
        -- Add horizontal influence
        local hit_pos = (ball.x - paddle.x) / paddle.width
        ball.dx = (hit_pos - 0.5) * 400
    end

    -- Ball fall off bottom
    if ball.y > love.graphics.getHeight() then
        love.load() -- restart
    end

    -- Ball-brick collisions
    for _, brick in ipairs(bricks) do
        if
            brick.alive
            and ball.x + ball.radius > brick.x
            and ball.x - ball.radius < brick.x + brick.width
            and ball.y + ball.radius > brick.y
            and ball.y - ball.radius < brick.y + brick.height
        then
            brick.hits = brick.hits - 1
            if brick.hits < 1 then
                brick.alive = false
            end
            ball.dy = -ball.dy
        end
    end
end

function love.draw()
    -- Draw paddle
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.width, paddle.height)

    -- Draw ball
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)

    -- Draw bricks
    for _, brick in ipairs(bricks) do
        if brick.alive then
            if brick.hits == 1 then
                love.graphics.setColor(1, 0, 0)
            end
            love.graphics.rectangle("fill", brick.x, brick.y, brick.width, brick.height)
        end
    end

    -- Win condition
    local win = true
    for _, brick in ipairs(bricks) do
        if brick.alive then
            win = false
            break
        end
    end
    if win then
        love.graphics.printf("You Win!", 0, 250, love.graphics.getWidth(), "center")
    end
end
