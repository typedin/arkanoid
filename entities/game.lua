local Ball = require("entities/ball")
local Level = require("entities/level")
local Paddle = require("entities/paddle")
local StateMachine = require("states/StateMachine")
local game_states = require("states/game_states")

local Game = {}

Game.__index = Game

function Game:new()
    local instance = {
        bricks = {},
        lives = 3,
        score = 0,
        stateMachine = StateMachine:new(game_states),
        paddle = Paddle:new(),
        ball = Ball:new(),
        level = Level:load(1),
    }

    setmetatable(instance, Game)

    return instance
end

function Game:next_level()
    self.level = self.level:next()
end

return Game
