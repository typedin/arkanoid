-- A player has a paddle
-- has a current level
-- has lives
local Player = {}

Player.__index = Player

---@param params PlayerConfig
---@return Player
function Player:new(params)
    assert(params.name, "Player:new requires a name")
    local instance = {
        name = params.name,
        lives = 3,
        current_level = 1,
        score = 0,
    }

    setmetatable(instance, Player)

    return instance
end

return Player
