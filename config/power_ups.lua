---@alias PowerUpName
---| "B" -– Break: Skips to the next level.
---| "C" -– Catch: Ball sticks to the paddle.
---| "D" -– slow Down: Ball moves slower.
---| "E" -– Expand: Makes the paddle wider.
---| "L" -– Laser: Paddle can shoot lasers.
---| "M" -– Multi balls: You get 3 balls.
---| "P" -– Player: Grants an extra life.
---| "S" -– Shrink: Shrinks the paddle.
---| "U" -- speed Up: Ball moves faster

---@class PowerUpDef
---@field name string
---@field rgb integer[] -- RGB color array: { r, g, b }

---@class PowerUps
---@field kinds table<PowerUpName, PowerUpDef>
local PowerUps = {
    B = {
        name = "break",
        rgb = { 0, 1, 1 }, -- Cyan
    },
    C = {
        name = "catch",
        rgb = { 1, 0.5, 0 }, -- Orange
    },
    D = {
        name = "slow_down",
        rgb = { 1, 1, 0 }, -- Yellow
    },
    E = {
        name = "extend",
        rgb = { 1, 0, 0 }, -- Red
    },
    L = {
        name = "laser",
        rgb = { 0.5, 0, 1 }, -- Purple
    },
    M = {
        name = "multiple_balls",
        rgb = { 1, 1, 0 }, -- Yellow
    },
    P = {
        name = "extra_life",
        rgb = { 1, 0, 1 }, -- Magenta
    },
    S = {
        name = "shrink",
        rgb = { 0, 0, 1 }, -- Blue
    },
    U = {
        name = "speed_up",
        rgb = { 0, 1, 0 }, -- Green
    },
}

return PowerUps
