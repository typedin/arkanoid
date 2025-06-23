local Score = require("entities/score")
local Life = require("entities/life")
local merge_table = require("libraries.merge_table")

local Player = {}

Player.__index = Player

---@class PlayerConfig
---@field name string
---@field score table
---@field live_area LiveArea
---@field score_area ScoreArea
---@field life LifeLayout

---@param params PlayerConfig
---@return Player
function Player:new(params)
    assert(params.name, "Player:new requires a name")
    assert(type(params.live_area) == "table", "Player:new requires a live area")
    -- TODO let the name and score be responsible for their display
    assert(type(params.score_area) == "table", "Player:new requires a score area")

    local instance = {
        name = params.name,
        current_level = 1,
        lives = {
            Life:new(merge_table.merge(params, { life_number = 1 })),
            Life:new(merge_table.merge(params, { life_number = 2 })),
            Life:new(merge_table.merge(params, { life_number = 3 })),
        },
        score = Score:new(params.score),
    }

    setmetatable(instance, Player)

    return instance
end

function Player:draw()
    love.graphics.print(self.name, 200, 200)
    self.score:draw()
    for _, life in ipairs(self.lives) do
        life:draw()
    end
end

return Player
