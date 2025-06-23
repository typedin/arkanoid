local Score = require("entities/score")
local Player = require("entities.player")

local Players = {}

---@class PlayersConfig
---@field players PlayerConfig[]
---@field hud HudArea
---@field live_area LiveArea
---@field life LifeLayout

---@return Player[]
function Players:create(params)
    assert(#params.players > 0, "Config:new requires at least 1 player")
    assert(#params.players <= 2, "Config:new cannot build more than 2 players")

    for index, player in ipairs(params.players) do
        assert(type(player.name) == "string", "Config:new requires a name (error at " .. index .. ")")
        assert(type(params.hud) == "table", "Config:new requires a hud table")
        assert(type(params.hud.subsections["player_" .. index]) == "table", "Config:new requires a hud subsections for players_1")
        assert(type(params.live_area) == "table", "Config:new requires a live area")
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
                score_area = params.hud.subsections["player_" .. index],
                life = params.life,
            })
        )
    end

    return players
end

return Players
