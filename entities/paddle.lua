local EntityBase = require("entities/entity_base")

local Paddle = setmetatable({}, { __index = EntityBase })
Paddle.__index = Paddle

---@param params Config
---@return Paddle
function Paddle:new(params)
    local instance = {
        width = params.layout.paddle.width,
        height = params.layout.paddle.height,
        speed = 400, --WARNING magic number
        x = ((params.layout.areas.live.width / 2) + params.layout.areas.live.x) - (params.layout.paddle.width / 2), -- center the paddle at the center of the live area
        y = params.layout.areas.live.paddle_line,
    }

    instance.last = {
        x = instance.x,
        y = instance.y,
    }

    setmetatable(instance, Paddle)

    return instance
end

function Paddle:update(dt, context)
    self.last.x = self.x
    self.last.y = self.y

    context.ball.last.x = context.ball.x
    context.ball.last.y = context.ball.y

    if love.keyboard.isDown("left") then
        if context.ball.glued then
            context.paddle = self
            context.ball:moveLeft({ dt = dt, speed = self.speed })
        end
        self:moveLeft(dt)
    elseif love.keyboard.isDown("right") then
        if context.ball.glued then
            context.paddle = self
            context.ball:moveRight({ dt = dt, speed = self.speed })
        end
        self:moveRight(dt)
    end
end

function Paddle:resolveCollision(context)
    -- reset the position
    if self:checkCollision(context.walls.right) then
        if context.ball.glued then
            context.ball.x = context.ball.last.x
            context.ball.y = context.ball.last.y
        end
        self.x = self.last.x
        self.y = self.last.y
    end
    if self:checkCollision(context.walls.left) then
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

function Paddle:draw()
    -- Draw paddle
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Paddle
