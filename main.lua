local Ball = require("entities/ball")
local Paddle = require("entities/paddle")
local layout = require("config/main").layout

local paddle
local ball
local bricks = {}
local lives = 3
local level = require("levels/" .. 1)

function love.load()
    love.window.setTitle("Arkanoid Clone")
    love.window.setMode(layout.resolution.width, layout.resolution.height)
    paddle = Paddle:new()
    ball = Ball:new()

    -- Initialize bricks
    for row = 1, layout.bricks.rows do
        for col = 1, layout.bricks.cols do
            table.insert(bricks, {
                x = (col - 1) * (layout.bricks.width + layout.bricks.margin) + layout.wall_left.x + layout.wall_left.thickness,
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
    paddle.x = math.max( --
        (layout.area.live.x + layout.wall.thickness),
        -- Have to divide by 2 for some reason
        math.min(paddle.x, layout.area.live.width - paddle.width - layout.wall.thickness / 2)
    )

    -- Ball movement
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    if ball.x + ball.radius / 2 > layout.wall_right.x - layout.wall_right.thickness then
        ball.dx = -ball.dx
    end
    if ball.x + ball.radius / 2 < layout.wall_left.x + layout.wall_left.thickness then
        ball.dx = -ball.dx
    end
    if ball.y + ball.radius / 2 < layout.wall_up.y + layout.wall_up.thickness then
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
    if ball.y > paddle.y + paddle.height then
        lives = lives - 1
        paddle = Paddle:new()
        ball = Ball:new()
        if lives == 0 then
            love.event.quit(0) -- restart
        end
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
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", layout.wall_left.x, layout.wall_left.y, layout.wall_left.width + layout.wall_left.thickness, layout.wall_left.height)
    love.graphics.rectangle("fill", layout.wall_up.x, layout.wall_up.y, layout.wall_up.width, layout.wall_up.height + layout.wall_left.thickness)
    love.graphics.rectangle("fill", layout.wall_right.x, layout.wall_right.y, layout.wall_right.width + layout.wall_left.thickness, layout.wall_right.height)
    -- Draw bricks
    for _, brick in ipairs(bricks) do
        if brick.alive then
            if brick.hits == 1 then
                love.graphics.setColor(1, 0, 0)
            end
            love.graphics.rectangle("fill", brick.x, brick.y, brick.width, brick.height)
        end
    end

    -- Draw paddle
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.width, paddle.height)

    -- Draw ball
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)

    -- Draw Lives
    for i = 1, lives do
        love.graphics.setColor(0, 1, 0)
        -- pox_x, pox_y, width, height
        love.graphics.rectangle("fill", layout.live.pos_x + (i - 1) * layout.live.margin_right, layout.live.pos_y, layout.live.width, layout.live.height)
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
