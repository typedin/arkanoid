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

---@alias PowerUpAction
---| "break"
---| "catch"
---| "slow_down"
---| "extend"
---| "laser"
---| "multiple_balls"
---| "extra_life"
---| "shrink"
---| "speed_up"

---@class PowerUpDef
---@field action PowerUpAction
---@field rgb integer[] -- RGB color array: { r, g, b }
---@field timer integer -- time in seconds before the power_up is removed

---@class PowerUps
---@field kinds table<PowerUpName, PowerUpDef>
local PowerUps = {
    B = {
        action = "break",
        rgb = { 0, 1, 1 }, -- Cyan
        time = 5,
    },
    C = {
        action = "catch",
        rgb = { 1, 0.5, 0 }, -- Orange
        time = 5,
    },
    D = {
        action = "slow_down",
        rgb = { 1, 1, 0 }, -- Yellow
        time = 5,
    },
    E = {
        action = "extend",
        rgb = { 1, 0, 0 }, -- Red
        time = 5,
    },
    L = {
        action = "laser",
        rgb = { 0.5, 0, 1 }, -- Purple
        time = 5,
    },
    M = {
        action = "multiple_balls",
        rgb = { 1, 1, 0 }, -- Yellow
        time = 5,
    },
    P = {
        action = "extra_life",
        rgb = { 1, 0, 1 }, -- Magenta
        time = 5,
    },
    S = {
        action = "shrink",
        rgb = { 0, 0, 1 }, -- Blue
        time = 5,
    },
    U = {
        action = "speed_up",
        rgb = { 0, 1, 0 }, -- Green
        time = 5,
    },
}

return PowerUps
