local EntityBase = require("entities/entity_base")

local Brick = {}

Brick.__index = Brick
setmetatable(Brick, { __index = EntityBase })

---@class BrickParams
---@field height number
---@field hits integer
---@field kind BrickName
---@field points integer
---@field power_up? PowerUpName
---@field rgb integer[]
---@field width number
---@field x number
---@field y number

---@param params BrickParams
---@return Brick
function Brick:new(params)
    assert(#params.rgb == 3, "params.rgb must have 3 values")
    assert(type(params.height) == "number", "params.height must be a number")
    assert(type(params.hits) == "number", "params.hits must be a number")
    assert(type(params.kind) == "string", "params.kind must be a string")
    assert(type(params.points) == "number", "params.points must be a number")
    assert(type(params.width) == "number", "params.width must be a number")
    assert(type(params.x) == "number", "params.x must be a number")
    assert(type(params.y) == "number", "params.y must be a number")

    for index, value in ipairs(params.rgb) do
        assert(type(value) == "number", "argument at " .. index .. " is not a number")
    end

    local instance = {
        height = params.height,
        hits = params.hits,
        kind = params.kind,
        points = params.points,
        rgb = params.rgb,
        width = params.width,
        x = params.x,
        y = params.y,
    }

    if params.power_up then
        assert(type(params.power_up) == "string", "params.power_up must be a string")
        instance.power_up = params.power_up
    end

    setmetatable(instance, Brick)

    return instance
end

function Brick:hit()
    self.hits = self.hits - 1
end

function Brick:draw()
    ---@diagnostic disable-next-line: param-type-mismatch
    ---@diagnostic disable-next-line: missing-parameter
    love.graphics.setColor(love.math.colorFromBytes(self.rgb))
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Brick
