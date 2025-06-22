local EntityBase = require("entities/entity_base")
local brick_kind = require("config/bricks").kinds

local Brick = {}

Brick.__index = Brick
setmetatable(Brick, { __index = EntityBase })

---@class BrickParams
---@field x number
---@field y number
---@field width number
---@field height number
---@field kind BrickKind

---@param params BrickParams
---@return Brick
function Brick:new(params)
    assert(type(params.x) == "number", "params.x must be a number")
    assert(type(params.y) == "number", "params.y must be a number")
    assert(type(params.width) == "number", "params.width must be a number")
    assert(type(params.height) == "number", "params.height must be a number")
    assert(type(params.kind) == "string", "params.kind must be a string")

    local instance = {
        x = params.x,
        y = params.y,
        width = params.width,
        height = params.height,
        kind = params.kind,
        hits = brick_kind[params.kind].hits,
        points = brick_kind[params.kind].points,
    }

    setmetatable(instance, Brick)

    return instance
end

function Brick:draw()
    ---@diagnostic disable-next-line: param-type-mismatch
    ---@diagnostic disable-next-line: missing-parameter
    love.graphics.setColor(love.math.colorFromBytes(brick_kind[self.kind].rgb))
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Brick
