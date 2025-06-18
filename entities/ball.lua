local Ball = {}

Ball.__index = Ball

---@param params Config
---@return Ball
function Ball:new(params)
    local paddle_line = params.layout.areas.live.height + 10
    local instance = {
        diameter = params.layout.ball.diameter,
        radius = params.layout.ball.diameter / 2,
        x = (params.layout.areas.live.width / 2) + params.layout.areas.live.x, -- center the paddle at the center of the live area
        y = paddle_line - params.layout.ball.diameter / 2, -- WARNING agic number
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
    self.x = self.x - context.speed * context.dt
end

function Ball:moveRight(context)
    if not self.glued then
        return
    end
    self.x = self.x + context.speed * context.dt
end

function Ball:draw()
    -- Draw ball
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.x, self.y, self.diameter / 2)
end

return Ball
