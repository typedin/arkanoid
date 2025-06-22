---@alias BrickName
---| '"gray"'
---| '"red"'
---| '"orange"'
---| '"yellow"'
---| '"green"'
---| '"blue"'
---| '"purple"'
---| '"white"'
---| '"cyan"'
---| '"silver"'
---| '"gold"'

---@class BrickDef
---@field hits integer
---@field points integer
---@field rgb integer[]  -- RGB color array: { r, g, b }

---@class Bricks
---@field kinds table<BrickName, BrickDef>
local bricks = {
    kinds = {
        gray = {
            hits = 1,
            points = 50,
            rgb = { 128, 128, 128 },
        },
        red = {
            hits = 1,
            points = 60,
            rgb = { 255, 8, 0 },
        },
        orange = {
            hits = 1,
            points = 70,
            rgb = { 255, 88, 0 },
        },
        yellow = {
            hits = 1,
            points = 80,
            rgb = { 255, 255, 51 },
        },
        green = {
            hits = 1,
            points = 90,
            rgb = { 102, 255, 0 },
        },
        blue = {
            hits = 1,
            points = 100,
            rgb = { 0, 72, 186 },
        },
        purple = {
            hits = 1,
            points = 110,
            rgb = { 191, 0, 255 },
        },
        white = {
            hits = 1,
            points = 120,
            rgb = { 255, 255, 255 },
        },
        cyan = {
            hits = 1,
            points = 130,
            rgb = { 0, 255, 255 },
        },
        silver = {
            hits = 2,
            points = 150,
            rgb = { 117, 117, 117 },
        },
        gold = {
            hits = math.huge, -- indestructible
            points = 0,
            rgb = { 255, 215, 0 },
        },
    },
}

return bricks
