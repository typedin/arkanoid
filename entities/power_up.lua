local collision = require("collision.rectangle")
local RectangleBase = require("entities.rectangle_base")
local PowerUps = require("config.power_ups")

local PowerUp = {}
PowerUp.__index = PowerUp
setmetatable(PowerUp, { __index = RectangleBase })

---@class PowerUpConfig
---@field height number
---@field name  PowerUpName
---@field speed number
---@field width number
---@field x number
---@field y number

---@param params PowerUpConfig
---@return PowerUp
function PowerUp:new(params)
    local instance = {
        action = PowerUps[params.name].action,
        dy = params.speed,
        height = params.height,
        name = params.name,
        rgb = PowerUps[params.name].rgb,
        width = params.width,
        x = params.x,
        y = params.y,
    }
    instance.destroyable = false

    setmetatable(instance, PowerUp)

    return instance
end

function PowerUp:markAsDestroyable()
    self.destroyable = true
end

--WARNING this class is defined in entities/power_up.lua

---@param context ResolveOutOfBoundContext
---@return boolean
function PowerUp:resolveOutOfBound(context)
    -- if power_up is out of bounds then ask the caller to destroy it
    return collision.check_out_of_bond(self, context.live_area)
end

---@class PowerUpCheckCollisionContext
---@field ball Ball
---@field game Game
---@field live_area LiveArea
---@field paddle Paddle
---@field player Player

---@param context PowerUpCheckCollisionContext
function PowerUp:resolveCollision(context)
    if collision.check_rectangle_collision(self, context.paddle) then
        -- player
        if self.action == "extra_life" then
            context.player:extraLife()
        -- game
        elseif self.action == "break" then
            context.game:nextLevel()
        elseif self.action == "multiple_balls" then
            context.game:spawnBalls(2)
        -- ball
        elseif self.action == "catch" then
            for _, ball in ipairs(context.game.balls) do
                ball:setGlued({ glued = true, paddle = context.paddle })
            end
        elseif self.action == "speed_up" then
            for _, ball in ipairs(context.game.balls) do
                ball:speedUp()
            end
        elseif self.action == "slow_down" then
            for _, ball in ipairs(context.game.balls) do
                ball:slowDown()
            end
        -- paddle
        elseif self.action == "extend" then
            context.paddle:extend()
        elseif self.action == "shrink" then
            context.paddle:shrink()
        elseif self.action == "laser" then
            context.paddle:equipLaser()
        end
        self:markAsDestroyable()
    end
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:draw()
    love.graphics.setColor(self.rgb[1], self.rgb[2], self.rgb[3])

    -- Draw the rectangle
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Draw border
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    -- Draw the name centered
    love.graphics.setColor(0, 0, 0) -- Black text
    local font = love.graphics.getFont()
    local text_width = font:getWidth(self.name)
    local text_height = font:getHeight()

    local text_x = self.x + (self.width - text_width) / 2
    local text_y = self.y + (self.height - text_height) / 2

    love.graphics.print(self.name, text_x, text_y)

    -- Reset color to white for subsequent drawing operations
    love.graphics.setColor(1, 1, 1)
end

return PowerUp
