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
---@field level? number  -- Optional level id from CLI, must be a number

---@param params GameParams
---@return Game
function Game:new(params)
    assert(type(params) == "table", "Game:new requires a params table")
    assert(type(params.players) == "table", "Game:new requires params.players to be a table")
    assert(type(params.screen) == "table", "Game:new requires params.screen to be a table")
    assert(type(params.resolution) == "table", "Game:new requires params.resolution to be a table")

    local layout_config = Layout:new({ resolution = params.resolution, screen = params.screen })

    local players = Players:create({
        power_up = layout_config.layout.power_up,
        brick = layout_config.layout.brick,
        hud = layout_config.layout.areas.hud,
        level_id = tonumber(params.level),
        life = layout_config.layout.life,
        live_area = layout_config.layout.areas.live,
        players = params.players,
    })

    local instance = {
        current_player = 1,
        balls = {},
        layout = layout_config.layout,
        lasers = {},
        -- same code in entities/game.lua line 84
        -- same code in entities/game.lua line 113
        paddle = Paddle:new({
            x = ((layout_config.layout.areas.live.width / 2) + layout_config.layout.areas.live.x) - (layout_config.layout.paddle.width / 2), -- center the paddle at the center of the live area
            y = layout_config.layout.areas.live.paddle_line,
            width = layout_config.layout.paddle.width,
            height = layout_config.layout.paddle.height,
            speed = require("config.physics.entities").paddle.speed,
        }),
        players = players,
        power_ups = {},
        stateMachine = StateMachine:new(game_states),
        walls = {
            left = Wall:new(layout_config.layout.areas.walls.left),
            top = Wall:new(layout_config.layout.areas.walls.top),
            right = Wall:new(layout_config.layout.areas.walls.right),
        },
    }

    setmetatable(instance, Game)

    -- initialize the game with 1 ball
    instance:spawnBalls(1)

    return instance
end

-- This function removes a live from the current player
-- if the player is a solo player, they're next
-- if there are 2 players, next player plays
function Game:nextPlayer()
    table.remove(self.players[self.current_player].lives)
    if #self.players == 2 then
        self.current_player = 3 - self.current_player -- it looks like it's a lua pattern
    end
    -- same code in entities/game.lua line 47
    -- same code in entities/game.lua line 117
    self.paddle = Paddle:new({
        x = ((self.layout.areas.live.width / 2) + self.layout.areas.live.x) - (self.layout.paddle.width / 2), -- center the paddle at the center of the live area
        y = self.layout.areas.live.paddle_line,
        width = self.layout.paddle.width,
        height = self.layout.paddle.height,
        speed = require("config.physics.entities").paddle.speed,
    })
    for i = #self.power_ups, 1, -1 do
        table.remove(self.power_ups, i)
    end
    self.balls = {}
    self:spawnBalls(1)
end

--- This funtion clears all movable objects
function Game:destroyMovables()
    -- destroy all balls
    for i = #self.balls, 1, -1 do
        table.remove(self.balls, i)
    end
    -- destroy all power_ups
    for i = #self.power_ups, 1, -1 do
        table.remove(self.power_ups, i)
    end
    -- destroy all lasers
    for i = #self.lasers, 1, -1 do
        table.remove(self.lasers, i)
    end
end

function Game:nextLevel()
    -- same code in entities/game.lua line 47
    -- same code in entities/game.lua line 84
    self.paddle = Paddle:new({
        x = ((self.layout.areas.live.width / 2) + self.layout.areas.live.x) - (self.layout.paddle.width / 2), -- center the paddle at the center of the live area
        y = self.layout.areas.live.paddle_line,
        width = self.layout.paddle.width,
        height = self.layout.paddle.height,
        speed = require("config.physics.entities").paddle.speed,
    })
    self.balls = {}
    self:spawnBalls(1)
    self.players[self.current_player].level = Level:load({
        id = self.players[self.current_player].level:getNext(),
        power_up = self.layout.power_up,
        brick = self.layout.brick,
        live_area = self.layout.areas.live,
    })
end

---@param number_of_balls number
function Game:spawnBalls(number_of_balls)
    -- max of 3 balls
    assert(type(number_of_balls) == "number", "Game:spawnBalls requires a number_of_balls")
    assert(number_of_balls < 3 and number_of_balls > 0, "Game:spawnBalls requires a number_of_balls between 1 and 3")

    for index = 1, number_of_balls do
        -- assign a random number between 100 and a resonable modification of require("config.physics.entities").ball.speed
        local dx = math.random(100, require("config.physics.entities").ball.speed)
        -- make sure that the 3 balls don't go the same direction
        if index == 2 then
            dx = dx * -1
        end

        local dy = require("config.physics.entities").ball.speed

        local glued = number_of_balls == 1
        table.insert(
            self.balls,
            index,
            Ball:new({
                dx = dx,
                dy = dy * -1, -- So I can see it
                glued = glued,
                diameter = self.layout.ball.diameter,
                x = (self.layout.areas.live.width / 2) + self.layout.areas.live.x,
                y = self.layout.areas.live.paddle_line - self.layout.ball.diameter / 2,
            })
        )
    end
end

return Game
