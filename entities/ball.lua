local collision = require("collision.rectangle")
local DiscBase = require("entities/circle_base")

local Ball = setmetatable({}, { __index = DiscBase })
Ball.__index = Ball

---@class BallConfig
---@field dx number
---@field dy number
---@field glued? boolean
---@field ball table
---@field live_area LiveArea

---@param params BallConfig
---@return Ball
function Ball:new(params)
    assert(type(params) == "table", "Ball:new requires a params table")
    assert(type(params.ball) == "table", "Ball:new requires params.ball to be a table")
    assert(type(params.live_area) == "table", "Ball:new requires params.live_area to be a table")
    assert(type(params.dx) == "number", "Ball:new requires params.dx to be a number")
    assert(type(params.dy) == "number", "Ball:new requires params.dy to be a number")

    assert(params.dy < 0, "Ball:new requires params.dy to less than 0")

    local instance = {
        dy = params.dy,
        dx = params.dx,
        diameter = params.ball.diameter,
        radius = params.ball.diameter / 2,
        x = (params.live_area.width / 2) + params.live_area.x, -- center the paddle at the center of the live area
        y = params.live_area.paddle_line - params.ball.diameter / 2,
    }

    if type(params.glued) ~= "boolean" then
        instance.glued = true
    else
        instance.glued = params.glued
    end

    instance.last = {
        x = instance.x,
        y = instance.y,
    }

    setmetatable(instance, Ball)

    return instance
end

-- TODO params
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

---@param axis string
function Ball:invert(axis)
    assert(axis == "dx" or axis == "dy", "Ball:invert can only be called with dx or dy")

    self[axis] = -self[axis]
end

---@class DiscGeometry
---@field left number
---@field top number
---@field right number
---@field bottom number
---@field center number

---@param dt number
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

---@param context BallMoveContext
function Ball:moveLeft(context)
    self.x = self.x - context.speed * context.dt
end

---@param context BallMoveContext
function Ball:moveRight(context)
    self.x = self.x + context.speed * context.dt
end

function Ball:markAsDestroyable()
    self.destroyable = true
end

function Ball:resolveOutOfBound(context)
    return collision.check_out_of_bond(self, context.live_area)
end

---@class BallCollisionContext
---@field paddle Paddle
---@field walls Walls

---@param context BallCollisionContext
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

---@class SetGluedContext
---@field paddle Paddle
---@field glued boolean

---@param context SetGluedContext
function Ball:setGlued(context)
    -- set the ball to the middle of the paddle
    self.x = context.paddle.x + context.paddle.width / 2
    -- set the ball to top of the paddle
    self.y = context.paddle:getGeometry().top - self.radius
    self.glued = context.glued
end

function Ball:slowDown()
    self.dx = self.dx - 50
    self.dy = self.dy - 50
end

function Ball:speedUp()
    self.dx = self.dx + 50
    self.dy = self.dy + 50
end

function Ball:update(dt)
    self.last.x = self.x
    self.last.y = self.y
    if not self.glued then
        self:move(dt)
    end
end

return Ball
