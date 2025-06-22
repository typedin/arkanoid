local EntityBase = require("entities/entity_base")
local Life = {}

Life.__index = Life

setmetatable(Life, { __index = EntityBase })

local function calculateX(params)
    local margin_left = 5

    local first_life_position = (params.live_area.x + (params.life.width / 2))
    local right_offset = (params.life.width + margin_left) * (params.life_number - 1)

    return first_life_position + right_offset
end

---@class LifeParams
---@field live_area LiveArea
---@field life LifeLayout
---@field life_number number

---@return Life
function Life:new(params)
    local instance = {
        x = calculateX(params),
        y = params.live_area.height + 35, -- WARNING agic number
        width = params.life.width,
        height = params.life.height,
    }

    setmetatable(instance, Life)

    return instance
end

function Life:draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Life
