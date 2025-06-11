local StateMachine = require("states/StateMachine")
local paddle_states = require("states/paddle_states")
local shallowCopy = require("libraries/shallow_copy")
local paddle = require("config/main").paddle

local Paddle = {}

Paddle.__index = Paddle

local function _clamp(value, min_x, max_x)
    return math.max(min_x, math.min(value, max_x))
end

function Paddle:new()
    local instance = shallowCopy(paddle)
    instance.stateMachine = StateMachine:new(paddle_states)

    setmetatable(instance, Paddle)

    return instance
end

function Paddle:move_left(context)
    local min_x = context.layout.area.live.x + context.layout.wall.thickness
    local max_x = context.layout.area.live.width - context.layout.wall.thickness / 2 - self.width
    self.x = _clamp(self.x - self.speed * context.dt, min_x, max_x)
end

function Paddle:move_right(context)
    local min_x = context.layout.area.live.x + context.layout.wall.thickness
    local max_x = context.layout.area.live.width - context.layout.wall.thickness / 2 - self.width
    self.x = _clamp(self.x + self.speed * context.dt, min_x, max_x)
end

function Paddle:draw()
    -- Draw paddle
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
return Paddle
