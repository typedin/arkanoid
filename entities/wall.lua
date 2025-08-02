local RectangleBase = require("entities.rectangle_base")

local Wall = {}
Wall.__index = Wall
setmetatable(Wall, { __index = RectangleBase })

---@class WallParams
---@field x number
---@field y number
---@field thickness number
---@field width number
---@field height number

---@param params WallParams
---@return Wall
function Wall:new(params)
    if not params then
        error("Wall:new requires params")
    end
    assert(type(params.x) == "number", "params.x must be a number")
    assert(type(params.y) == "number", "params.y must be a number")
    assert(type(params.thickness) == "number", "params.thickness must be a number")
    assert(type(params.width) == "number", "params.width must be a number")
    assert(type(params.height) == "number", "params.height must be a number")

    local instance = {
        x = params.x,
        y = params.y,
        thickness = params.thickness,
        width = params.width,
        height = params.height,
    }

    setmetatable(instance, Wall)

    return instance
end

function Wall:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Wall
