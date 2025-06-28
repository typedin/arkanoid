---@type StateMachineStateMap
local game_states = {
    menu = {
        enter = function() end,
        update = function() end,
        exit = function() end,
    },
    play = {
        enter = function() end,
        ---@param _ StateMachineState
        ---@param game Game
        ---@param dt number
        update = function(_, game, dt)
            for _, ball in ipairs(game.balls) do
                ball:update(dt)
                ball:resolveCollision({ walls = game.walls, paddle = game.paddle, bricks = game.players[game.current_player].level.bricks })
                game.paddle:update(dt, { ball = ball })
                game.paddle:resolveCollision({ walls = game.walls, ball = ball })
            end
            for _, power_up in ipairs(game.power_ups) do
                power_up:update(dt)
                power_up:resolveCollision({ live_area = game.layout.areas.live, paddle = game.paddle, player = game.players[game.current_player], game = game })
            end
        end,
        exit = function() end,
    },
    pause = {
        enter = function()
            print("entering pause")
        end,
        update = function()
            print("game in pause")
        end,
        exit = function()
            print("exiting pause")
        end,
    },
    over = {
        enter = function() end,
        update = function() end,
        exit = function() end,
    },
}

return game_states
