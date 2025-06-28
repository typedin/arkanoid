local Geometry = {}

-- ChatGPT:
-- You can make your geometry tables directly callable, returning their values in a tuple-like fashion:
-- Lua calls __call for tables treated as functions — which gives you a single value (the table) that also behaves like a multi-value call
Geometry.__call = function(self)
    return self.left, self.top, self.right, self.bottom, self.center
end

local DiscBase = {}

---@class Disc
---@field left number
---@field top number
---@field right number
---@field bottom number
---@field center number

---@return DiscGeometry
function DiscBase:getGeometry()
    local geometry = {
        left = self.x - self.radius, -- left
        top = self.y - self.radius, -- top
        right = self.x + self.radius, -- right
        bottom = self.y + self.radius, -- bottom
        center = self.x, -- center
    }

    return setmetatable(geometry, Geometry)
end

return DiscBase
