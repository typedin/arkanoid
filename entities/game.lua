local Game = {}

Game.__index = Game

function Game:new()
    local instance = {}

    setmetatable(instance, Game)

    return instance
end

return Game
