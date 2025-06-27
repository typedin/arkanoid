local PowerUps = require("config.power_ups")
--[[
Capsule type is predetermined at specific bricks per level, but those exact positions aren't publicly documented.
Silver/gold bricks don't drop capsules.
Early/mid levels have the most capsule bricks; late levels far fewer.
Fans haven't documented a full level‑by‑capsule breakdown, so your best bet is firsthand observation or fandom collaboration.
--]]

local PowerUp = {}
PowerUp.__index = PowerUp

---@class PowerUpConfig
---@field height number
---@field name  PowerUpName
---@field speed number
---@field width number
---@field x number
---@field y number

---@param params PowerUpConfig
---@return PowerUp
function PowerUp.new(params)
    local instance = {
        height = params.height,
        name = params.name,
        speed = params.speed,
        width = params.width,
        x = params.x,
        y = params.y,
    }

    setmetatable(instance, PowerUp)
    return instance
end

function PowerUp:draw()
    local color = PowerUps[self.name].color

    love.graphics.setColor(color[1], color[2], color[3])

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
