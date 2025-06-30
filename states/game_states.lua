local power_up_physics = require("config.physics.entities").power_up
local PowerUp = require("entities.power_up")

---@type StateMachineStateMap
local game_states = {
    menu = {
        enter = function() end,
        update = function() end,
        exit = function() end,
    },
    play = {
        enter = function() end,
        ---@param game Game
        ---@param dt number
        update = function(_, game, dt)
            --[[ 
			    WARNING /!\/!\
			    No stupid refactoring
			    -- CURSOR did this
			    -- Only use a update method for moving entities
			    -- Remove destroyable power-ups (iterate backwards to avoid index issues)
				 WARNING /!\/!\
			]]
            --
            for i = #game.power_ups, 1, -1 do
                local power_up = game.power_ups[i]
                power_up:update(dt)
                power_up:resolveCollision({ live_area = game.layout.areas.live, paddle = game.paddle, player = game.players[game.current_player], game = game })

                if power_up:resolveOutOfBound({ live_area = game.layout.areas.live }) then
                    power_up:markAsDestroyable()
                end

                if power_up.destroyable then
                    table.remove(game.power_ups, i)
                end
            end

            for i = #game.balls, 1, -1 do
                local ball = game.balls[i]
                game.paddle:update(dt, { ball = ball })
                game.paddle:resolveCollision({ walls = game.walls, ball = ball })
                ball:update(dt)
                ball:resolveCollision({ walls = game.walls, paddle = game.paddle })

                if ball:resolveOutOfBound({ live_area = game.layout.areas.live }) then
                    ball:markAsDestroyable()
                end

                if ball.destroyable then
                    table.remove(game.balls, i)
                end
            end

            for i = #game.lasers, 1, -1 do
                local laser = game.lasers[i]
                laser:update(dt)

                if laser:resolveOutOfBound({ live_area = game.layout.areas.live }) then
                    laser:markAsDestroyable()
                end

                if laser.destroyable then
                    table.remove(game.lasers, i)
                end
            end

            for i = #game.players[game.current_player].level.bricks, 1, -1 do
                local brick = game.players[game.current_player].level.bricks[i]
                for j = #game.balls, 1, -1 do
                    local ball = game.balls[j]
                    brick:resolveCollision({ ball = ball })
                end
                for j = #game.lasers, 1, -1 do
                    local laser = game.lasers[j]
                    brick:resolveCollision({ laser = laser })
                end

                if brick.hits < 1 then
                    brick:markAsDestroyable()
                    game.players[game.current_player].score:add(brick.points)
                end

                if brick.power_up and brick.hits < 1 then
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
                if brick.destroyable then
                    table.remove(game.players[game.current_player].level.bricks, i)
                end
            end
            --
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
