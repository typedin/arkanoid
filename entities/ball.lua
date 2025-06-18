local Ball = {}

Ball.__index = Ball

local function _clamp(value, min_x, max_x)
    return math.max(min_x, math.min(value, max_x))
end

---@param params Config
---@return Ball
function Ball:new(params)
    local instance = {
        diameter = params.layout.ball.diameter,
        x = (params.layout.areas.live.width + params.layout.areas.live.x / 2) + (params.layout.paddle.width / 2), -- ball should be glued at the middle of the paddle
        y = params.layout.areas.live.height - 10 - params.layout.paddle.height, -- WARNING agic number
        dx = 200, --WARNING magic number
        dy = -200, --WARNING magic number
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
    local max_x = context.layout.area.live.width - context.layout.wall.thickness / 2 - self.diameter / 2
    self.x = _clamp(self.x - context.speed * context.dt, min_x, max_x)
end

function Ball:moveRight(context)
    if not self.glued then
        return
    end
    local min_x = context.layout.area.live.x + context.layout.wall.thickness
    local max_x = context.layout.area.live.width - context.layout.wall.thickness / 2 - self.diameter / 2
    self.x = _clamp(self.x + context.speed * context.dt, min_x, max_x)
end

function Ball:draw()
    -- Draw ball
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.x, self.y, self.diameter / 2)
end

return Ball
