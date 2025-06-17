local Brick = require("entities/brick")
local layout = require("config/main").layout

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

local brickWidth = calculateBrickWidth(layout.area.live.width - layout.wall.thickness * 2, layout.bricks.margin, 13)

local function buildBricks(target, source)
    -- Initialize bricks
    -- iterate over rows
    for i, row in ipairs(source.rows) do
        for j, brick in ipairs(row) do
            -- IMPORTANT:
            -- Keep brickWidth out of Brick
            local x = (j - 1) * (brickWidth + layout.bricks.margin) + layout.wall_left.x + layout.wall.thickness
            local y = i * (layout.bricks.height + layout.bricks.margin) + layout.wall.thickness
            table.insert(
                target.bricks,
                Brick:new({
                    x = x,
                    y = y,
                    kind = brick.kind,
                    width = brickWidth,
                    height = layout.bricks.height,
                })
            )
        end
    end
end

local Level = {}

Level.__index = Level

function Level:load(level_name)
    -- don't load all levels at once for memory reasons
    local level = require("levels/" .. level_name)
    assert(type(level) == "table", "count not load level")
    assert(type(level.name) == "string", "params.name must be a string")
    assert(type(level.rows) == "table", "params.rows must be a table")

    local instance = {
        id = level_name,
        name = level.name,
        bricks = {},
    }
    -- this function assigns bricks to the level
    -- AND
    -- the number of bricks that are destroyable
    buildBricks(instance, level)

    setmetatable(instance, Level)

    return instance
end

function Level:next()
    return Level:load(self.id + 1)
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
