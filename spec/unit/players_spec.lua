---@diagnostic disable: undefined-field
local Players = require("config.players")

describe("Player", function()
    local fake_score_area = {
        x = 42,
        y = 42,
        width = 42,
        height = 42,
    }
    local fake_life = {
        x = 12,
        y = 12,
        width = 12,
        height = 12,
    }
    local hud_stub = {
        x = 0,
        y = 0,
        width = 42,
        height = 42,
        subsections = {
            player_1 = fake_score_area,
            player_2 = fake_score_area,
        },
    }
    ---@class LiveArea
    local fake_live_area = {
        x = 42,
        y = 42,
        width = 42,
        height = 42,
        pos_x = 12,
        pos_y = 12,
        paddle_line = 12,
    }

    it("default to one", function()
        local players = Players:create({ players = { { name = "me" } }, hud = hud_stub, live_area = fake_live_area, life = fake_life })

        assert.are.equal(1, #players)
        assert.are.equal("me", players[1].name)
        assert.are.equal(3, #players[1].lives)
        assert.are.equal(1, players[1].current_level)
        assert.are.equal(0, players[1].score.value)
    end)

    it("can build 2 players", function()
        local players = Players:create({ players = { { name = "me" }, { name = "you" } }, hud = hud_stub, live_area = fake_live_area, life = fake_life })

        assert.are.equal(2, #players)
        assert.are.equal("me", players[1].name)
        assert.are.equal(3, #players[1].lives)
        assert.are.equal("you", players[2].name)
        assert.are.equal(3, #players[2].lives)
    end)
end)
