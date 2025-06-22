local Ball = require("entities/ball")
local Level = require("entities/level")
local Life = require("entities/life")
local Paddle = require("entities/paddle")
local StateMachine = require("states/StateMachine")
local Wall = require("entities/wall")
local game_states = require("states/game_states")

local Game = {}

Game.__index = Game

---@param config Config
---@return Game
function Game:new(config)
    if not config then
        error("Game:new requires a config")
    end

    local instance = {
        config = config,
        paddle = Paddle:new(config),
        ball = Ball:new(config),
        walls = {
            left = Wall:new(config.layout.areas.walls.left),
            top = Wall:new(config.layout.areas.walls.top),
            right = Wall:new(config.layout.areas.walls.right),
        },
        stateMachine = StateMachine:new(game_states),
        score = 0,
        level = Level:load(1, config),
        lives = {
            Life:new(config, 1),
            Life:new(config, 2),
            Life:new(config, 3),
        },
    }

    setmetatable(instance, Game)

    return instance
end

function Game:nextLevel()
    self.level = self.level:next()
end

return Game
