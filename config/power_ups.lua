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
---@field timer integer -- timer in seconds before the power_up is removed

---@class PowerUps
---@field kinds table<PowerUpName, PowerUpDef>
local PowerUps = {
    B = {
        action = "break",
        rgb = { 0, 1, 1 }, -- Cyan
    },
    C = {
        action = "catch",
        rgb = { 1, 0.5, 0 }, -- Orange
        timer = 5,
    },
    D = {
        action = "slow_down",
        rgb = { 1, 1, 0 }, -- Yellow
        timer = 5,
    },
    E = {
        action = "extend",
        rgb = { 1, 0, 0 }, -- Red
        timer = 5,
    },
    L = {
        action = "laser",
        rgb = { 0.5, 0, 1 }, -- Purple
        timer = 10,
    },
    M = {
        action = "multiple_balls",
        rgb = { 1, 1, 0 }, -- Yellow
    },
    P = {
        action = "extra_life",
        rgb = { 1, 0, 1 }, -- Magenta
    },
    S = {
        action = "shrink",
        rgb = { 0, 0, 1 }, -- Blue
        timer = 5,
    },
    U = {
        action = "speed_up",
        rgb = { 0, 1, 0 }, -- Green
        timer = 5,
    },
}

return PowerUps
