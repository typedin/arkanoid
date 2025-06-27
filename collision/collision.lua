local Collision = {}

---@param game Game
function Collision.handle(game)
    Collision.ball_fell(game)
    Collision.ball_bricks(game)
end

---@param game Game
function Collision.paddle_left_wall(game)
    if game.paddle:getGeometry().left <= game.walls.left:getGeometry().right then
        return true
    end
    return false
end

---@param game Game
function Collision.paddle_right_wall(game)
    if game.paddle:getGeometry().right >= game.walls.right:getGeometry().left then
        return true
    end
    return false
end

---@param game Game
function Collision.ball_left_wall(game)
    if game.ball:getGeometry().left <= game.walls.left:getGeometry().right then
        return true
    end
    return false
end

---@param game Game
function Collision.ball_right_wall(game)
    if game.ball:getGeometry().right >= game.walls.right:getGeometry().left then
        return true
    end
    return false
end

---@param game Game
function Collision.ball_top_wall(game, dt)
    if game.ball:getGeometry().top + dt < game.walls.top:getGeometry().bottom then
        return true
    end
    return false
end

---@param game Game
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

---@param game Game
function Collision.ball_fell(game)
    if game.ball.y > game.paddle.y + game.paddle.height then
        game:nextRound()
    end
end

---@param game Game
function Collision.ball_bricks(game)
    local ball = game.ball
    local bricks = game.players[game.current_player].level.bricks

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
                game.players[game.current_player].score:add(brick.points)
            end
            ball.dy = -ball.dy
        end
    end
end

return Collision
