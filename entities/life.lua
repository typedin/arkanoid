local EntityBase = require("entities/entity_base")
local Life = {}

Life.__index = Life

setmetatable(Life, { __index = EntityBase })

local function calculateX(params)
    local margin_left = 5

    local first_life_position = (params.x + (params.width / 2))
    local right_offset = (params.width + margin_left) * (params.life_number - 1)

    return first_life_position + right_offset
end

---@class LifeParams
---@field x number
---@field y number
---@field width number
---@field height number

---@return Life
function Life:new(params)
    assert(type(params.x) == "number", "Life:new requires params.x to be a number")
    assert(type(params.y) == "number", "Life:new requires params.y to be a number")
    assert(type(params.width) == "number", "Life:new requires params.width to be a number")
    assert(type(params.height) == "number", "Life:new requires params.height to be a number")

    local instance = {
        x = calculateX(params),
        y = params.y + 35, -- WARNING agic number
        width = params.width,
        height = params.height,
    }

    setmetatable(instance, Life)

    return instance
end

function Life:draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Life
