local power_up_physics = require("config.physics.entities").power_up
local PowerUp = require("entities.power_up")
local Collision = {}

---@param ball Ball
---@param game Game
function Collision.handle(ball, game)
    Collision.ball_bricks(ball, game)
end

---@param ball Ball
---@param game Game
function Collision.ball_paddle(ball, game)
    if
        ball:getGeometry().bottom <= game.paddle:getGeometry().top
        and ball:getGeometry().center >= game.paddle:getGeometry().left
        and ball:getGeometry().center <= game.paddle:getGeometry().right
    then
        return true
    end
    return false
end

---@param ball Ball
---@param game Game
function Collision.ball_fell(ball, game)
    -- TODO
    -- if I use the live height it freezes the game
    -- figure out why
    -- TODO:
    if ball.y > game.paddle.y + game.paddle.height then
        return true
    end
    return false
end

---@param ball Ball
---@param game Game
function Collision.ball_bricks(ball, game)
    local bricks = game.players[game.current_player].level.bricks

    for _, brick in ipairs(bricks) do
        if
            brick.hits > 0
            and ball.x + ball.radius > brick.x
            and ball.x - ball.radius < brick.x + brick.width
            and ball.y + ball.radius > brick.y
            and ball.y - ball.radius < brick.y + brick.height
        then
            brick:hit()
            ball:invert("dy")
            if brick.hits < 1 then
                game.players[game.current_player].score:add(brick.points)
                -- instanciate the power_up here
                if brick.power_up then
                    table.insert(
                        game.power_ups,
                        PowerUp:new({
                            height = game.layout.power_up.height,
                            name = brick.power_up,
                            speed = power_up_physics.speed,
                            width = game.layout.power_up.width,
                            x = brick.x,
                            y = brick.y,
                        })
                    )
                end
            end
        end
    end
end

return Collision
