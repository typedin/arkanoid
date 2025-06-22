local Score = require("entities/score")
local Life = require("entities/life")
local merge_table = require("libraries.merge_table")

local Player = {}

Player.__index = Player

---@class PlayerConfig
---@field name string
---@field score table
---@field live_area LiveArea
---@field life LifeLayout

---@param params PlayerConfig
---@return Player
function Player:new(params)
    assert(params.name, "Player:new requires a name")
    assert(type(params.score.x) == "number", "Player:new require a score.x")
    assert(type(params.score.y) == "number", "Player:new require a score.y")

    assert(type(params.live_area) == "table", "Player:new requires a live area")
    assert(type(params.life) == "table", "Player:new requires a life table")

    local instance = {
        name = params.name,
        lives = {
            Life:new(merge_table.merge(params, { life_number = 1 })),
            Life:new(merge_table.merge(params, { life_number = 2 })),
            Life:new(merge_table.merge(params, { life_number = 3 })),
        },
        current_level = 1,
        score = Score:new(params.score),
    }

    setmetatable(instance, Player)

    return instance
end

return Player
