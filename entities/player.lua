local Player = {}

Player.__index = Player

---@class PlayerConfig
---@field name string
---@field score Score
---@field lives Life[]

---@param params PlayerConfig
---@return Player
function Player:new(params)
    assert(params.name, "Player:new requires a name")
    -- assert params have a score
    assert(params.score, "Player:new requires a score")
    -- assert params have 3 lives
    assert(#params.lives == 3, "Player:new requires 3 lives")

    local instance = {
        name = params.name,
        current_level = 1,
        lives = params.lives,
        score = params.score,
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
