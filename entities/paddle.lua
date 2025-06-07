local shallowCopy = require("libraries/shallow_copy")
local paddle = require("config/main").paddle

local Paddle = {}

Paddle.__index = Paddle

function Paddle:new()
    local instance = shallowCopy(paddle)

    setmetatable(instance, Paddle)

    return instance
end

function Paddle:move_left(dt)
    self.x = self.x - self.speed * dt
end

function Paddle:move_right(dt)
    self.x = self.x + self.speed * dt
end

return Paddle
