local RectangleBase = require("entities.rectangle_base")

local Paddle = setmetatable({}, { __index = RectangleBase })
Paddle.__index = Paddle

---@class PaddleConfig
---@field paddle table
---@field live_area table
---@field physics table

---@param params PaddleConfig
---@return Paddle
function Paddle:new(params)
    local instance = {
        hasLaser = false,
        isSticky = false,
        height = params.paddle.height,
        speed = params.physics.speed,
        width = params.paddle.width,
        _width = params.paddle.width, -- private as a backup value
        x = ((params.live_area.width / 2) + params.live_area.x) - (params.paddle.width / 2), -- center the paddle at the center of the live area
        y = params.live_area.paddle_line,
    }

    instance.last = {
        x = instance.x,
        y = instance.y,
    }

    setmetatable(instance, Paddle)

    return instance
end

---@class PaddleUpdateContext
---@field ball Ball

---@param dt number
---@param context PaddleUpdateContext
function Paddle:update(dt, context)
    self.last.x = self.x
    self.last.y = self.y

    context.ball.last.x = context.ball.x
    context.ball.last.y = context.ball.y

    if love.keyboard.isDown("left") then
        if context.ball.glued then
            -- WARNING was it used
            -- context.paddle = self
            context.ball:moveLeft({ dt = dt, speed = self.speed })
        end
        self:moveLeft(dt)
    elseif love.keyboard.isDown("right") then
        if context.ball.glued then
            -- WARNING was it used
            -- context.paddle = self
            context.ball:moveRight({ dt = dt, speed = self.speed })
        end
        self:moveRight(dt)
    end
end

function Paddle:resetSize()
    self.width = self._width
end

---@param wall Wall
function Paddle:is_out(wall)
    return self:getGeometry().left > wall:getGeometry().right
end

---@param context PaddleContext
function Paddle:move_out(context)
    self.speed = 100
    self:moveRight(context.dt)
end

---@class PaddleCollisionContext
---@field walls Walls
---@field ball Ball

---@param context PaddleCollisionContext
function Paddle:resolveCollision(context)
    -- reset the position
    if self:checkCollision(context.walls.right) then
        -- Put this somewhere else
        if context.ball.glued then
            context.ball.x = context.ball.last.x
            context.ball.y = context.ball.last.y
        end
        self.x = self.last.x
        self.y = self.last.y
    end
    if self:checkCollision(context.walls.left) then
        -- Put this somewhere else
        if context.ball.glued then
            context.ball.x = context.ball.last.x
            context.ball.y = context.ball.last.y
        end
        self.x = self.last.x
        self.y = self.last.y
    end
end

function Paddle:checkCollision(e)
    return self:getGeometry().right > e:getGeometry().left
        and self:getGeometry().left < e:getGeometry().right
        and self:getGeometry().bottom > e:getGeometry().top
        and self:getGeometry().top < e:getGeometry().bottom
end

function Paddle:moveLeft(dt)
    self.x = self.x - self.speed * dt
end

function Paddle:moveRight(dt)
    self.x = self.x + self.speed * dt
end

function Paddle:shrink()
    -- shrink by the half of the paddle
    self.width = self.width - (self.width / 2)
end

function Paddle:extend()
    -- extend by the half of the paddle
    self.width = self.width + (self.width / 2)
end

function Paddle:makeNonSticky()
    self.isSticky = false
end

function Paddle:makeSticky()
    self.isSticky = true
end

function Paddle:equipLaser()
    self.hasLaser = true
end

function Paddle:unequipLaser()
    self.hasLaser = false
end

function Paddle:draw()
    -- Draw paddle
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Paddle
