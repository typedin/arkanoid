local collision = require("collision.rectangle")
local Disc = require("entities/circle_base")

local Laser = {}
Laser.__index = Laser
setmetatable({}, { __index = Disc })

---@class LaserConfig
---@field dx number
---@field dy number
---@field x number -- where it was fired from
---@field y number -- where it was fired from
---@field diameter number

---@param params LaserConfig
---@return Laser
function Laser:new(params)
    -- Disc assertions
    assert(type(params.x) == "number", "params.x must be a number")
    assert(type(params.y) == "number", "params.y must be a number")
    assert(type(params.diameter) == "number", "params.diameter must be a number")
    assert(params.diameter > 0, "params.diameter must be greater than 0")

    -- Laser assertions
    assert(type(params.dx) == "number", "params.dx must be a number")
    assert(type(params.dy) == "number", "params.dy must be a number")
    assert(params.dy < 0, "params.dy must be negative")

    ---@class Laser
    local instance = Disc.new(self, {
        diameter = params.diameter,
        radius = params.diameter / 2,
        x = params.x,
        y = params.y,
    })

    instance.dx = params.dx
    instance.dy = params.dy
    instance.destroyable = false

    instance.last = {
        x = instance.x,
        y = instance.y,
    }

    setmetatable(instance, Laser)

    return instance
end

function Laser:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

function Laser:markAsDestroyable()
    self.destroyable = true
end

---@param dt number
function Laser:move(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Laser:resolveOutOfBound(context)
    return collision.check_out_of_bond(self, context.live_area)
end

---@param dt  number
function Laser:update(dt)
    self.last.x = self.x
    self.last.y = self.y
    self:move(dt)
end

return Laser
