local EntityBase = require("entities/entity_base")

local Ball = setmetatable({}, { __index = EntityBase })
Ball.__index = Ball

---@param params Config
---@return Ball
function Ball:new(params)
    local instance = {
        diameter = params.layout.ball.diameter,
        radius = params.layout.ball.diameter / 2,
        x = (params.layout.areas.live.width / 2) + params.layout.areas.live.x, -- center the paddle at the center of the live area
        y = params.layout.areas.live.paddle_line - params.layout.ball.diameter / 2,
        dx = 200, --WARNING magic number
        dy = -200, --WARNING magic number
        glued = true,
    }

    instance.last = {
        x = instance.x,
        y = instance.y,
    }

    setmetatable(instance, Ball)

    return instance
end

function Ball:update(dt)
    self.last.x = self.x
    self.last.y = self.y
    if not self.glued then
        self:move(dt)
    end
end

function Ball:resolveCollision(context)
    if self:checkCollision(context.walls.right) then
        self.x = self.last.x
        self.y = self.last.y
        self:invert("dx")
    end
    if self:checkCollision(context.walls.left) then
        self.x = self.last.x
        self.y = self.last.y
        self:invert("dx")
    end
    if self:checkCollision(context.walls.top) then
        self.x = self.last.x
        self.y = self.last.y
        self:invert("dy")
    end
    if self:checkCollision(context.paddle) then
        self.x = self.last.x
        self.y = self.last.y
        self:invert("dy")
    end
end

function Ball:checkCollision(e)
    return self:getGeometry().right > e:getGeometry().left
        and self:getGeometry().left < e:getGeometry().right
        and self:getGeometry().bottom > e:getGeometry().top
        and self:getGeometry().top < e:getGeometry().bottom
end

function Ball:getGeometry()
    local geometry = {
        left = self.x - self.radius, -- left
        top = self.y - self.radius, -- top
        right = self.x + self.radius, -- right
        bottom = self.y + self.radius, -- bottom
        center = self.x, -- center
    }

    return setmetatable(geometry, EntityBase)
end

function Ball:invert(axis)
    assert(axis == "dx" or axis == "dy", "Ball:invert can only be called with dx or dy")

    self[axis] = -self[axis]
end

function Ball:move(dt)
    if self.glued then
        return
    end
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:moveLeft(context)
    self.x = self.x - context.speed * context.dt
end

function Ball:moveRight(context)
    self.x = self.x + context.speed * context.dt
end

function Ball:draw()
    -- Draw ball
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Ball
