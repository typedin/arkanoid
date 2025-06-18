local StateMachine = require("states/StateMachine")
local paddle_states = require("states/paddle_states")

local Paddle = {}

Paddle.__index = Paddle

---@param params Config
---@return Paddle
function Paddle:new(params)
    local instance = {
        width = params.layout.paddle.width,
        height = params.layout.paddle.height,
        speed = 400, --WARNING magic number
        x = (params.layout.areas.live.width + params.layout.areas.live.x) / 2 - (params.layout.paddle.width / 2), -- center the paddle at the center of the live area
        y = params.layout.areas.live.height + 10, -- WARNING agic number
        stateMachine = StateMachine:new(paddle_states),
    }

    setmetatable(instance, Paddle)

    return instance
end

function Paddle:move_left(context)
    self.x = self.x - self.speed * context.dt
end

function Paddle:move_right(context)
    self.x = self.x + self.speed * context.dt
end

function Paddle:draw()
    -- Draw paddle
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Paddle
