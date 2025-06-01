local paddle = {
    x = 300,
    y = 550,
    width = 100,
    height = 20,
    speed = 400,
}

local ball = {
    x = 350,
    y = 300,
    radius = 10,
    dx = 200,
    dy = -200,
}

local bricks = {}
local brick_rows = 5
local brick_cols = 10
local brick_width = 60
local brick_height = 20
local brick_margin = 5

local level = require("levels/" .. 1)
function love.load()
    love.window.setTitle("Arkanoid Clone")
    love.window.setMode(800, 600)

    -- Initialize bricks
    for row = 1, brick_rows do
        for col = 1, brick_cols do
            table.insert(bricks, {
                x = (col - 1) * (brick_width + brick_margin) + 60,
                y = row * (brick_height + brick_margin),
                width = brick_width,
                height = brick_height,
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
            brick.alive = false
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
