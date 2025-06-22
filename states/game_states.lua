---@type StateMachineStateMap
local game_states = {
    menu = {
        enter = function() end,
        update = function() end,
        exit = function() end,
    },
    play = {
        enter = function() end,
        update = function(_, game, context)
            game.paddle:update({ dt = context.dt, walls = game.walls, ball = game.ball })
            game.paddle:resolveCollision({ dt = context.dt, walls = game.walls, ball = game.ball })
            game.ball:update({ dt = context.dt, walls = game.walls, paddle = game.paddle, bricks = game.level.bricks })
            game.ball:resolveCollision({ dt = context.dt, walls = game.walls, paddle = game.paddle, bricks = game.level.bricks })
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
