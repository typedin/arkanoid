---@class BallLayout
---@field diameter number

---@class BonusLayout
---@field width number
---@field height number

---@class BrickLayout
---@field width number
---@field height number

---@class LifeLayout
---@field width number
---@field height number

---@class PaddleLayout
---@field width number
---@field height number

---@class WallLayout
---@field thickness number

-- default for 320x200
return {
    ball = { diameter = 4 },
    bonus = { width = 16, height = 8 },
    brick = { width = 16, height = 8 },
    life = { width = 16, height = 6 },
    paddle = { width = 32, height = 8 },
    wall = { thickness = 8 },
}
