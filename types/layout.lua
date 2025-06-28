---@class Layout
---@field areas Areas
---@field ball BallLayout
---@field bonus BonusLayout
---@field brick BrickLayout
---@field power_up PowerUpLayout
---@field life LifeLayout
---@field paddle PaddleLayout
---@field wall WallLayout

---@class Areas
---@field active ActiveArea
---@field hud HudArea
---@field live LiveArea
---@field walls table<WallName, WallArea>

---@class ActiveArea
---@field x number
---@field y number
---@field width number
---@field height number

---@class LiveArea
---@field x number
---@field y number
---@field width number
---@field height number
---@field margin_right number
---@field pos_x number
---@field pos_y number
---@field paddle_line number
---@field life_line number

---@class HudArea
---@field x number
---@field y number
---@field width number
---@field height number

---@class ScoreArea
---@field x number
---@field y number
---@field width number
---@field height number

---@alias WallName
---| "left"
---| "right"
---| "top"

---@class WallArea
---@field x number
---@field y number
---@field width number
---@field height number
---@field thickness number
