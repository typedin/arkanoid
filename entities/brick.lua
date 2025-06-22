local EntityBase = require("entities/entity_base")

local Brick = {}

Brick.__index = Brick
setmetatable(Brick, { __index = EntityBase })

---@class BrickParams
---@field x number
---@field y number
---@field width number
---@field height number
---@field kind BrickName
---@field hits integer
---@field points integer
---@field rgb integer[]

---@param params BrickParams
---@return Brick
function Brick:new(params)
    assert(type(params.x) == "number", "params.x must be a number")
    assert(type(params.y) == "number", "params.y must be a number")
    assert(type(params.width) == "number", "params.width must be a number")
    assert(type(params.height) == "number", "params.height must be a number")
    assert(type(params.kind) == "string", "params.kind must be a string")
    assert(type(params.hits) == "number", "params.hits must be a number")
    assert(type(params.points) == "number", "params.points must be a number")
    assert(#params.rgb == 3, "params.rgb must have 3 values")
    for index, value in ipairs(params.rgb) do
        assert(type(value) == "number", "argument at " .. index .. " is not a number")
    end

    local instance = {
        x = params.x,
        y = params.y,
        width = params.width,
        height = params.height,
        kind = params.kind,
        hits = params.hits,
        points = params.points,
        rgb = params.rgb,
    }

    setmetatable(instance, Brick)

    return instance
end

function Brick:draw()
    ---@diagnostic disable-next-line: param-type-mismatch
    ---@diagnostic disable-next-line: missing-parameter
    love.graphics.setColor(love.math.colorFromBytes(self.rgb))
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Brick
