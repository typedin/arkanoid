---@class Layout
---@field wall_left Wall
---@field wall_up Wall
---@field wall_right Wall
---@field bricks Bricks
---@field area Area
---@field resolution Resolution

---@class Wall
---@field x number
---@field y number
---@field width number
---@field height number
---@field thickness number

---@class Bricks
---@field rows number
---@field cols number
---@field width number
---@field height number
---@field margin number
---@field kinds BricksKinds

---@class BricksKinds
---@field [string] BricksKind

---@class BricksKind
---@field points number
---@field hits number
---@field rgb string

---@class Area
---@field live Live
---@field hud Hud

---@class Live
---@field x number
---@field y number
---@field width number
---@field height number
---@field margin_right number
---@field pos_x number
---@field pos_y number

---@class Hud
---@field x number
---@field y number
