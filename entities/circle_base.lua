local Geometry = {}

-- ChatGPT:
-- You can make your geometry tables directly callable, returning their values in a tuple-like fashion:
-- Lua calls __call for tables treated as functions — which gives you a single value (the table) that also behaves like a multi-value call
Geometry.__call = function(self)
    return self.left, self.top, self.right, self.bottom, self.center
end

local DiscBase = {}

---@class DiscGeometry
---@field bottom number
---@field center_x number
---@field center_y number
---@field center number
---@field half_height number
---@field half_width number
---@field left number
---@field right number
---@field top number

---@return DiscGeometry
function DiscBase:getGeometry()
    local geometry = {
        top = self.y - self.radius, -- top
        right = self.x + self.radius, -- right
        bottom = self.y + self.radius, -- bottom
        left = self.x - self.radius, -- left
        half_width = self.radius, -- half width
        half_height = self.radius, -- half height
        center_x = self.x, -- center
        center_y = self.y, -- center
    }

    return setmetatable(geometry, Geometry)
end

return DiscBase
