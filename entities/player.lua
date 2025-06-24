local Player = {}

Player.__index = Player

---@class PlayerConfig
---@field name string
---@field score Score
---@field lives Life[]
---@field level Level
---@field level_id? string  -- Optional level id from CLI

---@param params PlayerConfig
---@return Player
function Player:new(params)
    assert(params.name, "Player:new requires a name")
    assert(params.score, "Player:new requires a score")
    assert(#params.lives == 3, "Player:new requires 3 lives")
    assert(params.level, "Player:new requires a level")

    local instance = {
        name = params.name,
        lives = params.lives,
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

return Player
