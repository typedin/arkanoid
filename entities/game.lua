local Ball = require("entities/ball")
local Level = require("entities/level")
local Paddle = require("entities/paddle")
local StateMachine = require("states/StateMachine")
local game_states = require("states/game_states")

local Game = {}

Game.__index = Game

function Game:new(config)
    if not config then
        error("Game:new requires a config")
    end
    local instance = {
        config = config,
        bricks = {},
        lives = 3,
        score = 0,
        stateMachine = StateMachine:new(game_states),
        paddle = Paddle:new(config),
        ball = Ball:new(config),
        level = Level:load(1),
    }

    setmetatable(instance, Game)

    return instance
end

function Game:nextLevel()
    self.level = self.level:next()
end

return Game
