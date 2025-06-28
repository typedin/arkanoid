local collision = require("collision.rectangle")
local EntityBase = require("entities/entity_base")
local PowerUps = require("config.power_ups")
--[[
Capsule type is predetermined at specific bricks per level, but those exact positions aren't publicly documented.
Silver/gold bricks don't drop capsules.
Early/mid levels have the most capsule bricks; late levels far fewer.
Fans haven't documented a full level‑by‑capsule breakdown, so your best bet is firsthand observation or fandom collaboration.
--]]

local PowerUp = {}
PowerUp.__index = PowerUp
setmetatable(PowerUp, { __index = EntityBase })

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

---@class PowerUpCheckCollisionContext
---@field live_area LiveArea
---@field ball Ball
---@field paddle Paddle
---@field player Player
---@field game Game
---@param context PowerUpCheckCollisionContext
function PowerUp:resolveCollision(context)
    -- if power_up is out of bounds then ask the caller to destroy it
    if self:getGeometry().bottom > context.live_area.height then
        self:markAsDestroyable()
    end
    if collision.check_rectangle_collision(self, context.paddle) then
        if self.name == "break" then
            context.game:nextLevel()
        elseif self.name == "catch" then
            for _, ball in ipairs(context.game.balls) do
                ball.glued = true
            end
        elseif self.name == "slow_down" then
            context.ball:slowDown()
        elseif self.name == "extend" then
            context.paddle:extend()
        elseif self.name == "laser" then
            context.paddle:laser()
        elseif self.name == "multiple_balls" then
            context.game:spawnBalls(2)
        elseif self.name == "extra_life" then
            context.player:extraLife()
        elseif self.name == "shrink" then
            context.paddle:shrink()
        elseif self.name == "speed_up" then
            context.ball:speedUp()
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
end

return PowerUp
