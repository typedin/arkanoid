---@class ConfigParams
---@field screen Screen
---@field resolution Resolution

---@class Screen
---@field width number
---@field height number

---@class Resolution
---@field width number
---@field height number

---@class Entity
---@field width? number
---@field height? number
---@field thickness? number
---@field diameter? number

---@class ScaledEntity
---@field width? number
---@field height? number
---@field thickness? number
---@field diameter? number

---@class Area
---@field x number
---@field y number
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

---@class Areas
---@field active Area
---@field live Area
---@field hud Area
---@field walls Walls

---@class Layout
---@field areas Areas
---@field ball ScaledEntity
---@field paddle ScaledEntity
---@field brick ScaledEntity
---@field life ScaledEntity
---@field bonus ScaledEntity
---@field wall ScaledEntity

---@class Config
---@field screen Screen
---@field resolution Resolution
---@field layout Layout
---@field new fun(params: ConfigParams): Config
---@field _apply_resolution fun(): Config
