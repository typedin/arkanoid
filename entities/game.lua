local Ball = require("entities/ball")
local Layout = require("config.layout")
local Level = require("entities/level")
local Paddle = require("entities/paddle")
local Players = require("config.players")
local StateMachine = require("states/StateMachine")
local Wall = require("entities/wall")
local game_states = require("states/game_states")

local Game = {}

Game.__index = Game

---@class GameParams
---@field players PlayerConfig[]
---@field screen Screen
---@field resolution Resolution

---@param params GameParams
---@return Game
function Game:new(params)
    assert(type(params) == "table", "Game:new requires a params table")
    assert(type(params.players) == "table", "Game:new requires params.players to be a table")
    assert(type(params.screen) == "table", "Game:new requires params.screen to be a table")
    assert(type(params.resolution) == "table", "Game:new requires params.resolution to be a table")

    local layout_config = Layout:new({ resolution = params.resolution, screen = params.screen })

    local players = Players:create({
        players = params.players,
        hud = layout_config.layout.areas.hud,
        live_area = layout_config.layout.areas.live,
        life = layout_config.layout.life,
        brick = layout_config.layout.brick,
    })

    local instance = {
        ball = Ball:new({
            ball = layout_config.layout.ball,
            live_area = layout_config.layout.areas.live,
            physics = require("config.physics.entities").ball,
        }),
        current_player = 1,
        layout = layout_config.layout,
        paddle = Paddle:new({
            paddle = layout_config.layout.paddle,
            live_area = layout_config.layout.areas.live,
            physics = require("config.physics.entities").paddle,
        }),
        players = players,
        stateMachine = StateMachine:new(game_states),
        walls = {
            left = Wall:new(layout_config.layout.areas.walls.left),
            top = Wall:new(layout_config.layout.areas.walls.top),
            right = Wall:new(layout_config.layout.areas.walls.right),
        },
    }

    setmetatable(instance, Game)

    return instance
end

function Game:nextRound()
    table.remove(self.players[self.current_player].lives)
    if #self.players == 2 then
        if self.current_player == 1 then
            self.current_player = 2
        elseif self.current_player == 2 then
            self.current_player = 1
        end
    end
    self.paddle = Paddle:new({
        paddle = self.layout.paddle,
        live_area = self.layout.areas.live,
        physics = require("config.physics.entities").paddle,
    })
    self.ball = Ball:new({
        ball = self.layout.ball,
        live_area = self.layout.areas.live,
        physics = require("config.physics.entities").ball,
    })
end

function Game:nextLevel()
    self.players[self.current_player].level = Level:load({
        id = self.players[self.current_player].level:getNext(),
        brick = self.layout.brick,
        live_area = self.layout.areas.live,
    })
end

return Game
