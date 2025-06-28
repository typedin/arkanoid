local Life = require("entities/life")
local merge_table = require("libraries.merge_table")
local Player = {}

Player.__index = Player

---@class PlayerConfig
---@field name string
---@field score Score
---@field life_params LifeParams
---@field level Level
---@field level_id? string  -- Optional level id from CLI

---@param params PlayerConfig
---@return Player
function Player:new(params)
    assert(params.name, "Player:new requires a name")
    assert(params.score, "Player:new requires a score")
    assert(params.level, "Player:new requires a level")
    assert(type(params.life_params) == "table", "Player:new requires a life_params table")
    assert(type(params.life_params.x) == "number", "Player:new requires params.life_params.x to be a number")
    assert(type(params.life_params.y) == "number", "Player:new requires params.life_params.y to be a number")
    assert(type(params.life_params.width) == "number", "Player:new requires params.life_params.width to be a number")
    assert(type(params.life_params.height) == "number", "Player:new requires params.life_params.height to be a number")

    local instance = {
        name = params.name,
        life_params = params.life_params,
        lives = {
            Life:new(merge_table.merge(params.life_params, { life_number = 1 })),
            Life:new(merge_table.merge(params.life_params, { life_number = 2 })),
            Life:new(merge_table.merge(params.life_params, { life_number = 3 })),
        },
        score = params.score,
        level = params.level,
    }

    setmetatable(instance, Player)

    return instance
end

function Player:draw()
    self.score:draw()
    for _, life in ipairs(self.lives) do
        life:draw()
    end
end

function Player:extraLife()
    local index = #self.lives + 1
    table.insert(
        self.lives,
        index,
        Life:new({
            x = self.life_params.x,
            y = self.life_params.y,
            width = self.life_params.width,
            height = self.life_params.height,
            life_number = index,
        })
    )
end

return Player
