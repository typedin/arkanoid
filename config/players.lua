local Score = require("entities/score")
local Life = require("entities/life")
local merge_table = require("libraries.merge_table")
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

    assert(type(params.hud) == "table", "Config:new requires a hud table")
    assert(type(params.live_area) == "table", "Config:new requires a live area")
    assert(type(params.life) == "table", "Config:new requires a life table")
    assert(type(params.life.height) == "number", "params.life.height must be a number")
    assert(type(params.life.width) == "number", "params.life.width must be a number")

    for index, player in ipairs(params.players) do
        assert(type(player.name) == "string", "Config:new requires a name (error at " .. index .. ")")
        assert(type(params.hud.subsections["player_" .. index]) == "table", "Config:new requires a hud subsections for players_1")
    end

    local players = {}

    for index, player in ipairs(params.players) do
        local x = params.hud.x + params.hud.width / 2
        local y = params.hud.y + params.hud.height / 2

        local life_params = {
            x = params.live_area.x,
            y = params.live_area.height + 35,
            width = params.life.width,
            height = params.life.height,
        }

        local lives = {
            Life:new(merge_table.merge(life_params, { life_number = 1 })),
            Life:new(merge_table.merge(life_params, { life_number = 2 })),
            Life:new(merge_table.merge(life_params, { life_number = 3 })),
        }

        local score = Score:new({ x = x, y = y * index })
        table.insert(players, index, Player:new({ name = player.name, lives = lives, score = score }))
    end

    return players
end

return Players
