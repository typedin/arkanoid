local EntityBase = require("entities/entity_base")

local Ball = setmetatable({}, { __index = EntityBase })
Ball.__index = Ball

---@class BallConfig
---@field ball table
---@field live_area table
---@field physics table

---@param params BallConfig
---@return Ball
function Ball:new(params)
    local instance = {
        glued = true,
        dx = params.physics.speed,
        dy = -params.physics.speed,
        diameter = params.ball.diameter,
        radius = params.ball.diameter / 2,
        x = (params.live_area.width / 2) + params.live_area.x, -- center the paddle at the center of the live area
        y = params.live_area.paddle_line - params.ball.diameter / 2,
    }

    instance.last = {
        x = instance.x,
        y = instance.y,
    }

    setmetatable(instance, Ball)

    return instance
end

function Ball:checkCollision(e)
    return self:getGeometry().right > e:getGeometry().left
        and self:getGeometry().left < e:getGeometry().right
        and self:getGeometry().bottom > e:getGeometry().top
        and self:getGeometry().top < e:getGeometry().bottom
end

function Ball:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

---@return DiscGeometry
---@diagnostic disable-next-line: duplicate-set-field
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

---@class BallCollisionContext
---@field walls Walls

---@class DiscGeometry
---@field left number
---@field top number
---@field right number
---@field bottom number
---@field center number

function Ball:move(dt)
    if self.glued then
        return
    end
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

---@class BallMoveContext
---@field dt number
---@field speed number
---
---@param context BallMoveContext
function Ball:moveLeft(context)
    self.x = self.x - context.speed * context.dt
end

---@param context BallMoveContext
function Ball:moveRight(context)
    self.x = self.x + context.speed * context.dt
end

---@params context BallCollisionContext
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

---@param glued boolean
function Ball:setGlued(glued)
    self.glued = glued
end

function Ball:slowDown()
    print("slowDown not implemented")
end

function Ball:speedUp()
    print("speedUp not implemented")
end

function Ball:update(dt)
    self.last.x = self.x
    self.last.y = self.y
    if not self.glued then
        self:move(dt)
    end
end

return Ball
