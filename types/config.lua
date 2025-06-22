---@class Config
---@field screen Screen
---@field resolution Resolution
---@field layout Layout
---@field new fun(params: ConfigParams): Config
---@field _apply_resolution fun(): Config

---@class ConfigParams
---@field screen Screen
---@field resolution Resolution

---@class Screen
---@field width number
---@field height number

---@class Resolution
---@field width number
---@field height number

---@class Wall
---@field x number
---@field y number
---@field width number
---@field height number
---@field thickness number

---@class Walls
---@field left Wall
---@field right Wall
---@field top Wall
