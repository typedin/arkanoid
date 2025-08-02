local Game = require("entities.game")
local Laser = require("entities.laser")
local parse_args = require("libraries.parse_args")
local cli_args = parse_args()
local merge_table = require("libraries.merge_table")
local resolutions = require("config.resolutions")

local game

-- TODO this to the config
local timer = 0
local throttle_interval = 0.17

function love.load()
    -- needed in Game:spawnBalls
    math.randomseed(os.time())
    love.window.setTitle("Arkanoid Clone")
    love.window.setMode(640, 480)

    local game_params = {
        players = { { name = "me" } },
        resolution = resolutions["amiga"],
        screen = { width = 640, height = 480 },
    }

    merge_table.merge(game_params, cli_args)

    if type(game_params.players[1]) == "string" then
        local names = game_params.players
        game_params.players = {}
        for _, n in ipairs(names) do
            table.insert(game_params.players, { name = n })
        end
    end

    game = Game:new(game_params)

    game.stateMachine:change("play")

    -- Use cli_args as needed
    if cli_args.debug then
        print("Debug mode enabled!")
    end
    if cli_args.level then
        print("Start at level:", cli_args.level)
    end
    if cli_args.players then
        print("Players:", table.concat(cli_args.players, ", "))
    end
    if cli_args.bonus then
        print("Bonuses:", table.concat(cli_args.bonus, ", "))
    end
end

function love.update(dt)
    -- first argument received by update is _self_
    game.stateMachine:update(game, dt)

    if love.keyboard.isDown("space") then
        for _, ball in ipairs(game.balls) do
            ball.glued = false
        end

        if game.paddle.hasLaser then
            timer = timer + dt
            if timer > throttle_interval then
                local dx = require("config.physics.entities").laser.speed.x
                local dy = require("config.physics.entities").laser.speed.y
                table.insert(
                    game.lasers,
                    Laser:new({
                        dx = dx,
                        dy = dy,
                        diameter = game.layout.laser.diameter,
                        x = game.paddle.x + game.layout.laser.offset,
                        y = game.paddle.y - game.layout.laser.diameter / 2,
                    })
                )
                table.insert(
                    game.lasers,
                    Laser:new({
                        dx = dx,
                        dy = dy,
                        diameter = game.layout.laser.diameter,
                        x = game.paddle.x + game.paddle.width - game.layout.laser.offset,
                        y = game.paddle.y - game.layout.laser.diameter / 2,
                    })
                )
                timer = timer - throttle_interval
            end
        else
            timer = 0
        end
    end

    if love.keyboard.isDown("p") then
        game.stateMachine:change("pause")
    elseif love.keyboard.isDown("r") then
        game.stateMachine:change("resume")
    end

    -- Must check if each player has
    -- no more lives
    -- no cleared the current level
    -- no balls ?????
    if #game.balls == 0 and #game.players == 2 and #game.players[game.current_player].lives and not game.players[game.current_player].level:cleared() then
        game.stateMachine:change("over")
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)

    game.paddle:draw()

    for _, laser in ipairs(game.lasers) do
        laser:draw()
    end
    for _, wall in pairs(game.walls) do
        wall:draw()
    end
    for _, brick in ipairs(game.players[game.current_player].level.bricks) do
        brick:draw()
    end
    for _, ball in ipairs(game.balls) do
        ball:draw()
    end
    for _, power_up in ipairs(game.power_ups) do
        power_up:draw()
    end
    for _, player in ipairs(game.players) do
        player:draw()
    end
end
