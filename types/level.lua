---@class Level
---@field id number
---@field name string
---@field bricks Brick[]

---@class LevelFile
---@field name string
---@field rows LevelFileRow[][]

---@class LevelFileRow
---@field kind BrickName
---@field power_up? PowerUpName
