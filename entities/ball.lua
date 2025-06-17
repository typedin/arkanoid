local ball = require("config/main").ball

local Ball = {}

Ball.__index = Ball

local function _clamp(value, min_x, max_x)
    return math.max(min_x, math.min(value, max_x))
end

---@return Ball
function Ball:new()
    local instance = {
        x = ball.x,
        y = ball.y,
        dx = ball.dx,
        dy = ball.dy,
        radius = ball.radius,
        glued = true,
    }

    setmetatable(instance, Ball)

    return instance
end

function Ball:invert(axis)
    assert(axis == "dx" or axis == "dy")
    self[axis] = -self[axis]
end

function Ball:move(context)
    if self.glued then
        return
    end
    self.x = self.x + self.dx * context.dt
    self.y = self.y + self.dy * context.dt
end

function Ball:moveLeft(context)
    if not self.glued then
        return
    end
    local min_x = context.layout.area.live.x + context.layout.wall.thickness
    local max_x = context.layout.area.live.width - context.layout.wall.thickness / 2 - self.radius
    self.x = _clamp(self.x - context.speed * context.dt, min_x, max_x)
end

function Ball:moveRight(context)
    if not self.glued then
        return
    end
    local min_x = context.layout.area.live.x + context.layout.wall.thickness
    local max_x = context.layout.area.live.width - context.layout.wall.thickness / 2 - self.radius
    self.x = _clamp(self.x + context.speed * context.dt, min_x, max_x)
end

function Ball:draw()
    -- Draw ball
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Ball
