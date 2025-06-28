---@class Brick
---@field new fun(self: Brick): Brick
---@field hit fun(self: Brick)
---@field draw fun(self: Brick)
---@field x number
---@field y number
---@field width number
---@field height number
---@field hits number
---@field points number
---@field kind BrickKind
---@field power_up? PowerUpName

---@class BricksKinds
---@field [string] BrickKind

---@class BrickKind
---@field hits number
---@field points number
---@field rgb integer[]  -- RGB color array: { r, g, b }
