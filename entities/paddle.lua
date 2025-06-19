local Paddle = {}

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

    setmetatable(instance, Paddle)

    return instance
end

function Paddle:moveLeft(context)
    self.x = self.x - self.speed * context.dt
end

function Paddle:moveRight(context)
    self.x = self.x + self.speed * context.dt
end

function Paddle:draw()
    -- Draw paddle
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Paddle
