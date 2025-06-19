local Life = {}

Life.__index = Life

local function calculateX(params, life_number)
    local margin_left = 5

    local first_life_position = (params.layout.areas.live.x + (params.layout.life.width / 2))
    local right_offset = (params.layout.life.width + margin_left) * (life_number - 1)

    return first_life_position + right_offset
end

function Life:new(params, life_number)
    local instance = {
        x = calculateX(params, life_number),
        y = params.layout.areas.live.height + 35, -- WARNING agic number
        width = params.layout.life.width,
        height = params.layout.life.height,
    }

    setmetatable(instance, Life)

    return instance
end

function Life:draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Life
