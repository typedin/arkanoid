local Geometry = {}

-- ChatGPT:
-- You can make your geometry tables directly callable, returning their values in a tuple-like fashion:
-- Lua calls __call for tables treated as functions — which gives you a single value (the table) that also behaves like a multi-value call
Geometry.__call = function(self)
    return self.left, self.top, self.right, self.bottom, self.center
end

local Rectangle = {}

---@class RectangleConfig
---@field x number
---@field y number
---@field width number
---@field height number

---@param params RectangleConfig
---@return Rectangle
function Rectangle:new(params)
    local instance = {
        x = params.x,
        y = params.y,
        width = params.width,
        height = params.height,
    }

    setmetatable(instance, Rectangle)

    return instance
end

---@class RectangleGeometry
---@field top number
---@field right number
---@field bottom number
---@field left number
---@field center_x number
---@field center_y number
---@field half_width number
---@field half_height number

---@return RectangleGeometry
function Rectangle:getGeometry()
    local geometry = {
        top = self.y, -- top
        right = self.x + self.width, -- right
        bottom = self.y + self.height, -- bottom
        left = self.x, -- left
        half_width = self.width / 2, -- half width
        half_height = self.height / 2, -- half height
        center_x = self.x + self.width / 2, -- center x
        center_y = self.y + self.height / 2, -- center y
    }

    return setmetatable(geometry, Geometry)
end

return Rectangle
