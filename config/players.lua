local Level = require("entities/level")
local Score = require("entities/score")
local Player = require("entities.player")

local Players = {}

---@class PlayersConfig
---@field players PlayerConfig[]
---@field hud HudArea
---@field live_area LiveArea
---@field life LifeLayout
---@field brick BrickLayout
---@field level_id? number  -- Optional level id from CLI, must be a number

---@return Player[]
function Players:create(params)
    assert(#params.players > 0, "Config:new requires at least 1 player")
    assert(#params.players <= 2, "Config:new cannot build more than 2 players")

    assert(type(params.hud) == "table", "Config:new requires a hud table")
    assert(type(params.live_area) == "table", "Config:new requires a live area")
    assert(type(params.life) == "table", "Config:new requires a life table")
    assert(type(params.life.height) == "number", "params.life.height must be a number")
    assert(type(params.life.width) == "number", "params.life.width must be a number")
    assert(params.brick, "Players:create requires a level")
    if params.level_id ~= nil then
        assert(type(params.level_id) == "number", "level_id must be a number if provided")
    end

    for index, player in ipairs(params.players) do
        assert(type(player.name) == "string", "Config:new requires a name (error at " .. index .. ")")
        assert(type(params.hud.subsections["player_" .. index]) == "table", "Config:new requires a hud subsections for players_1")
    end

    local players = {}

    for index, player in ipairs(params.players) do
        local life_params = {
            x = params.live_area.x,
            y = params.live_area.life_line,
            width = params.life.width,
            height = params.life.height,
        }

        local score_params = {
            x = params.hud.subsections["player_" .. index].x,
            y = params.hud.subsections["player_" .. index].y,
            width = params.hud.subsections["player_" .. index].width,
            height = params.hud.subsections["player_" .. index].height,
            player_name = player.name,
        }

        local score = Score:new(score_params)
        local level_id = params.level_id or 1
        local level = Level:load({
            id = level_id,
            brick = params.brick,
            power_up = params.power_up,
            live_area = params.live_area,
        })
        table.insert(players, index, Player:new({ name = player.name, life_params = life_params, score = score, level = level }))
    end

    return players
end

return Players
