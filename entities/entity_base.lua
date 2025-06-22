local Geometry = {}

-- ChatGPT:
-- You can make your geometry tables directly callable, returning their values in a tuple-like fashion:
-- Lua calls __call for tables treated as functions — which gives you a single value (the table) that also behaves like a multi-value call
Geometry.__call = function(self)
    return self.left, self.top, self.right, self.bottom, self.center
end

local EntityBase = {}

function EntityBase:getGeometry()
    local geometry = {
        left = self.x, -- left
        top = self.y, -- top
        right = self.x + self.width, -- right
        bottom = self.y + self.height, -- bottom
        center = self.x + self.width / 2, -- center
    }
    return setmetatable(geometry, Geometry)
end

return EntityBase
