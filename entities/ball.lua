local ball = require("config/main").ball

local Ball = {}

Ball.__index = Ball

---@return Ball
function Ball:new()
    local instance = {
        x = ball.x,
        y = ball.y,
        dx = ball.dx,
        dy = ball.dy,
        radius = ball.radius,
    }

    setmetatable(instance, Ball)

    return instance
end

function Ball:invert(axis)
    assert(axis == "dx" or axis == "dy")
    self[axis] = -self[axis]
end

function Ball:move(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

return Ball
