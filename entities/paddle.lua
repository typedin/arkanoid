local EntityBase = require("entities/entity_base")

local Paddle = setmetatable({}, { __index = EntityBase })
Paddle.__index = Paddle

---@param params Config
---@return Paddle
function Paddle:new(params)
    local paddle_line = params.layout.areas.live.height + 10
    local instance = {
        width = params.layout.paddle.width,
        height = params.layout.paddle.height,
        speed = 400, --WARNING magic number
        x = ((params.layout.areas.live.width / 2) + params.layout.areas.live.x) - (params.layout.paddle.width / 2), -- center the paddle at the center of the live area
        y = paddle_line, -- WARNING agic number
    }

    instance.last = {
        x = instance.x,
        y = instance.y,
    }

    setmetatable(instance, Paddle)

    return instance
end

function Paddle:update(context)
    self.last.x = self.x
    self.last.y = self.y

    context.ball.last.x = context.ball.x
    context.ball.last.y = context.ball.y

    if love.keyboard.isDown("left") then
        if context.ball.glued then
            context.paddle = self
            context.ball:moveLeft(context)
        end
        self:moveLeft(context)
    elseif love.keyboard.isDown("right") then
        if context.ball.glued then
            context.paddle = self
            context.ball:moveRight(context)
        end
        self:moveRight(context)
    end
end

function Paddle:moveLeft(context)
    self.x = self.x - self.speed * context.dt
end

function Paddle:moveRight(context)
    self.x = self.x + self.speed * context.dt
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

function Paddle:draw()
    -- Draw paddle
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Paddle
