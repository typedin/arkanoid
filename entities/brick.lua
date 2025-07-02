local RectangleBase = require("entities.rectangle_base")

local Brick = {}

Brick.__index = Brick
setmetatable(Brick, { __index = RectangleBase })

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
        destroyable = false,
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

function Brick:markAsDestroyable()
    self.destroyable = true
end

---@param ball Ball
function Brick:resolveBallCollision(ball)
    if ball ~= nil and self.hits > 0 then
        local ball_left = ball:getGeometry().left
        local ball_right = ball:getGeometry().right
        local ball_top = ball:getGeometry().top
        local ball_bottom = ball:getGeometry().bottom

        local brick_left = self:getGeometry().left
        local brick_right = self:getGeometry().right
        local brick_top = self:getGeometry().top
        local brick_bottom = self:getGeometry().bottom

        -- AABB collision check
        if ball_right > brick_left and ball_left < brick_right and ball_bottom > brick_top and ball_top < brick_bottom then
            -- Determine collision side (optional, for more realistic bounce)
            local overlap_left = ball_right - brick_left
            local overlap_right = brick_right - ball_left
            local overlap_top = ball_bottom - brick_top
            local overlap_bottom = brick_bottom - ball_top

            local min_overlap = math.min(overlap_left, overlap_right, overlap_top, overlap_bottom)

            if min_overlap == overlap_left or min_overlap == overlap_right then
                ball:invert("dx")
            else
                ball:invert("dy")
            end

            self.hits = self.hits - 1
            return true
        end
    end
    return false
end

---@param laser Laser
function Brick:resolveLaserCollision(laser)
    assert(type(laser) ~= "nil", "laser must not be nil")
    if
        laser.x + laser.radius > self.x
        and laser.x - laser.radius < self.x + self.width
        and laser.y + laser.radius > self.y
        and laser.y - laser.radius < self.y + self.height
    then
        -- It's not necessary to extract a function
        self.hits = self.hits - 1
        laser:markAsDestroyable()
        return true
    end
    return false
end

function Brick:draw()
    ---@diagnostic disable-next-line: param-type-mismatch
    ---@diagnostic disable-next-line: missing-parameter
    love.graphics.setColor(love.math.colorFromBytes(self.rgb))
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Brick
