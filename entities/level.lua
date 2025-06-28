local brick_kind = require("config.bricks").kinds
local Brick = require("entities.brick")

--- Calculates the width of a single brick based on the live area, spacing, and brick count.
---@param areaWidth number - total usable width for all bricks (no padding on sides)
---@param spacing number - space between adjacent bricks
---@param brickCount integer - max number of bricks per row
---@return number - width of a single brick
local calculateBrickWidth = function(areaWidth, spacing, brickCount)
    if brickCount < 1 then
        return 0
    end

    local totalSpacing = (brickCount - 1) * spacing
    local availableWidth = areaWidth - totalSpacing
    return availableWidth / brickCount
end

-- this function assigns bricks to the level
-- AND
-- the number of bricks that are destroyable
---@param instance table
---@param level LevelFile
---@param params LevelParams
local function buildBricks(instance, level, params)
    local brickWidth = calculateBrickWidth(params.live_area.width, 0, 13)
    -- Initialize bricks
    -- iterate over rows
    for i, row in ipairs(level.rows) do
        for j, brick in ipairs(row) do
            -- IMPORTANT:
            -- Keep brickWidth out of Brick
            local x = (j - 1) * brickWidth + params.live_area.x
            local y = i * params.brick.height + params.live_area.y
            local power_up = brick.power_up
            table.insert(
                instance.bricks,
                Brick:new({
                    height = params.brick.height,
                    hits = brick_kind[brick.kind].hits,
                    kind = brick.kind,
                    points = brick_kind[brick.kind].points,
                    power_up = power_up,
                    rgb = brick_kind[brick.kind].rgb,
                    width = brickWidth,
                    x = x,
                    y = y,
                })
            )
        end
    end
end

local Level = {}

Level.__index = Level

---@class LevelParams
---@field id number
---@field live_area table
---@field brick table
---@field power_up table

---@param params LevelParams
---@return Level
function Level:load(params)
    -- don't load all levels at once for memory reasons
    -- explicitly cast the level name to a string
    ---@type LevelFile
    local level = require("levels/" .. tostring(params.id))
    assert(type(level) == "table", "count not load level")
    assert(type(level.name) == "string", "params.name must be a string")
    assert(type(level.rows) == "table", "params.rows must be a table")

    local instance = {
        bricks = {},
        id = params.id,
        name = level.name,
    }

    buildBricks(instance, level, params)

    setmetatable(instance, Level)

    return instance
end

---@return number
function Level:getNext()
    return self.id + 1
end

function Level:cleared()
    -- total of bricks minus the number of bricks that have been destroyed - the number of bricks that are gold
    -- compute the number of bricks that are desctructible
    -- remove the number of bricks that are undestructible (aka gold)
    local total = #self.bricks
    for _, brick in ipairs(self.bricks) do
        if brick.hits == 0 then
            total = total - 1
        end
        if brick.kind == "gold" then
            total = total - 1
        end
    end

    return total == 0
end

return Level
