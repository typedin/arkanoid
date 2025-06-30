---@class BallLayout
---@field diameter number

---@class BonusLayout
---@field width number
---@field height number

---@class BrickLayout
---@field width number
---@field height number

---@class PowerUpLayout
---@field width number
---@field height number

---@class LaserLayout
---@field diameter number
---@field offset number

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
    laser = { diameter = 4, offset = 6 }, -- offset from the paddle as it cannot be at the extremities
    life = { width = 16, height = 6 },
    paddle = { width = 32, height = 8 },
    power_up = { width = 16, height = 8 },
    wall = { thickness = 8 },
}
