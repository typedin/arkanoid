---@class Level
---@field load fun(params: LevelParams): Level
---@field getNext fun(self: Level): number
---@field cleared fun(self: Level): boolean
---@field id number
---@field name string
---@field bricks Brick[]
---@field next boolean

---@class LevelFile
---@field name string
---@field rows LevelFileRow[][]

---@class LevelFileRow
---@field kind BrickName
---@field power_up? PowerUpName
