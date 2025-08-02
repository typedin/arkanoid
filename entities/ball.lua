local collision = require("collision.rectangle")
local Disc = require("entities/circle_base")

local Ball = {}
Ball.__index = Ball
setmetatable(Ball, { __index = Disc })

---@class BallConfig
---@field diameter number
---@field dx number
---@field dy number
---@field x number
---@field y number
---@field glued? boolean

---@param params BallConfig
---@return Ball
function Ball:new(params)
    -- Disc assertions
    assert(type(params.x) == "number", "Ball:new requires params.x to be a number")
    assert(type(params.y) == "number", "Ball:new requires params.y to be a number")
    assert(type(params.diameter) == "number", "params.diameter must be a number")
    assert(params.diameter > 0, "params.diameter must be greater than 0")

    -- Ball assertions
    assert(type(params.dx) == "number", "Ball:new requires params.dx to be a number")
    assert(type(params.dy) == "number", "Ball:new requires params.dy to be a number")
    assert(params.dy < 0, "Ball:new requires params.dy to less than 0")

    ---@class Ball
    local instance = Disc.new(self, {
        diameter = params.diameter,
        radius = params.diameter / 2,
        x = params.x,
        y = params.y,
    })

    instance.dy = params.dy
    instance.dx = params.dx
    instance._dy = params.dy -- private as a backup value
    instance._dx = params.dx -- private as a backup value

    instance.last = {
        x = instance.x,
        y = instance.y,
    }

    if type(params.glued) ~= "boolean" then
        instance.glued = true
    else
        instance.glued = params.glued
    end

    setmetatable(instance, Ball)

    return instance
end

-- TODO params
function Ball:checkCollision(e)
    return collision.check_rectangle_collision(self, e)
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

---@class ResolveOutOfBoundContext
---@field live_area LiveArea

---@param context ResolveOutOfBoundContext
---@return boolean
function Ball:resolveOutOfBound(context)
    return collision.check_out_of_bond(self, context.live_area)
end

---@class BallCollisionContext
---@field paddle Paddle
---@field walls Walls

---@param context BallCollisionContext
function Ball:resolveCollision(context)
    if self:checkCollision(context.walls.right) or self:checkCollision(context.walls.left) then
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
        if context.paddle.isSticky then
            self:stickToPaddle({
                paddle = context.paddle,
                x = self.x,
                y = self.y,
            })
        else
            if
                collision.get_collision_side(self, context.paddle, self.dx, self.dy) == "left"
                or collision.get_collision_side(self, context.paddle, self.dx, self.dy) == "right"
            then
                self.x = self.last.x
                self.y = self.last.y
                self:invert("dx")
            elseif
                collision.get_collision_side(self, context.paddle, self.dx, self.dy) == "top"
                or collision.get_collision_side(self, context.paddle, self.dx, self.dy) == "bottom"
            then
                self.x = self.last.x
                self.y = self.last.y
                self:invert("dy")
            end
        end
    end
end

---@class SetStickToPaddleContext
---@field x number
---@field y number

---@param context SetStickToPaddleContext
function Ball:stickToPaddle(context)
    self.glued = true
    self.x = context.x
    self.y = context.y
    if self.dy > 0 then
        self:invert("dy")
    end
end

function Ball:slowDown()
    -- TODO
    -- better physics
    self.dx = self.dx - 50
    self.dy = self.dy - 50
end

function Ball:speedUp()
    -- TODO
    -- better physics
    self.dx = self.dx + 50
    self.dy = self.dy + 50
end

function Ball:resetSpeed()
    self.dx = self._dx
    self.dy = self._dy
end

function Ball:update(dt)
    self.last.x = self.x
    self.last.y = self.y
    if not self.glued then
        self:move(dt)
    end
end

return Ball
