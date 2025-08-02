local Rectangle = require("entities.rectangle_base")

local Wall = {}
Wall.__index = Wall
setmetatable(Wall, { __index = Rectangle })

---@param params WallArea
---@return Wall
function Wall:new(params)
    -- Rectangle assertions
    assert(type(params.x) == "number", "params.x must be a number")
    assert(type(params.y) == "number", "params.y must be a number")
    assert(type(params.width) == "number", "params.width must be a number")
    assert(type(params.height) == "number", "params.height must be a number")

    -- Wall assertions
    assert(type(params.thickness) == "number", "params.thickness must be a number")

    ---@class Wall
    local instance = Rectangle.new(self, {
        x = params.x,
        y = params.y,
        width = params.width,
        height = params.height,
    })

    instance.thickness = params.thickness

    setmetatable(instance, Wall)

    return instance
end

function Wall:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Wall
