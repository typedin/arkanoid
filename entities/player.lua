local Score = require("entities/score")
local Life = require("entities/life")

local Player = {}

Player.__index = Player

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
            Life:new(params, 1),
            Life:new(params, 2),
            Life:new(params, 3),
        },
        current_level = 1,
        score = Score:new(params.score),
    }

    setmetatable(instance, Player)

    return instance
end

return Player
