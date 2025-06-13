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
        glued = false,
    }

    setmetatable(instance, Ball)

    return instance
end

function Ball:invert(axis)
    assert(axis == "dx" or axis == "dy")
    self[axis] = -self[axis]
end

function Ball:move(context)
    if self.x + self.radius / 2 > context.layout.wall_right.x - context.layout.wall_right.thickness then
        self:invert("dx")
    end
    if self.x - self.radius / 2 < context.layout.wall_left.x + context.layout.wall_left.thickness then
        self:invert("dx")
    end
    if self.y + self.radius / 2 < context.layout.wall_up.y + context.layout.wall_up.thickness then
        self:invert("dy")
    end
    self.x = self.x + self.dx * context.dt
    self.y = self.y + self.dy * context.dt
end

function Ball:move_left(context)
    local min_x = context.layout.area.live.x + context.layout.wall.thickness
    local max_x = context.layout.area.live.width - context.layout.wall.thickness / 2 - self.width
    self.x = _clamp(self.x - self.speed * context.dt, min_x, max_x)
end

function Ball:move_right(context)
    local min_x = context.layout.area.live.x + context.layout.wall.thickness
    local max_x = context.layout.area.live.width - context.layout.wall.thickness / 2 - self.width
    self.x = _clamp(self.x + self.speed * context.dt, min_x, max_x)
end

function Ball:draw()
    -- Draw ball
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Ball
