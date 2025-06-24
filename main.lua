local Collision = require("collision/collision")
local Game = require("entities/game")
local resolutions = require("config.resolutions")
local parse_args = require("libraries.parse_args")
local merge_table = require("libraries.merge_table")
local cli_args = parse_args()

local game

function love.load()
    love.window.setTitle("Arkanoid Clone")
    love.window.setMode(640, 480)

    local game_params = {
        players = { { name = "me" }, { name = "you" } },
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
    Collision.handle(game)

    if game.players[game.current_player].level:cleared() then
        game:nextLevel()
    end

    if love.keyboard.isDown("space") then
        game.ball.glued = false
    end

    if love.keyboard.isDown("p") then
        game.stateMachine:change("pause")
    elseif love.keyboard.isDown("r") then
        game.stateMachine:change("resume")
    end
end

function love.draw()
    -- key value pairs
    for _, wall in pairs(game.walls) do
        wall:draw()
    end
    -- Draw bricks
    for _, brick in ipairs(game.players[game.current_player].level.bricks) do
        if brick.hits > 0 then
            brick:draw()
        end
    end

    game.paddle:draw()
    game.ball:draw()

    for _, player in ipairs(game.players) do
        player:draw()
    end
end
