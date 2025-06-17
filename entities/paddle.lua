local StateMachine = require("states/StateMachine")
local paddle_states = require("states/paddle_states")
local shallowCopy = require("libraries/shallow_copy")
local paddle = require("config/main").paddle

local Paddle = {}

Paddle.__index = Paddle

function Paddle:new()
    local instance = shallowCopy(paddle)
    instance.stateMachine = StateMachine:new(paddle_states)

    setmetatable(instance, Paddle)

    return instance
end

function Paddle:move_left(context)
    self.x = self.x - self.speed * context.dt
end

function Paddle:move_right(context)
    self.x = self.x + self.speed * context.dt
end

function Paddle:draw()
    -- Draw paddle
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
return Paddle
