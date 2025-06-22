local Score = require("entities/score")
local Player = require("entities.player")

local Players = {}

---@param params PlayersConfig
---@return Player[]
function Players:create(params)
    assert(#params.players > 0, "Config:new requires at least 1 player")
    assert(#params.players <= 2, "Config:new cannot build more than 2 players")
    for index, player in ipairs(params.players) do
        assert(type(player.name) == "string", "Config:new requires a name (error at " .. index .. ")")
    end
    local players = {}
    for index, player in ipairs(params.players) do
        local x = params.hud.x + params.hud.width / 2
        local y = params.hud.y + params.hud.height / 2
        table.insert(
            players,
            index,
            Player:new({
                name = player.name,
                score = Score:new({ x = x, y = y * index }),
                live_area = params.live_area,
                life = params.life,
            })
        )
    end

    return players
end

return Players
