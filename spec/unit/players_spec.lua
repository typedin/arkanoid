---@diagnostic disable: undefined-field
local Players = require("config.players")
local layout_stub = require("spec.__fixtures__.layouts")

describe("Player", function()
    local fake_life = layout_stub.layout.life
    ---@class Hud
    local hud_stub = layout_stub.layout.areas.hud
    ---@class LiveArea
    local fake_live_area = layout_stub.layout.areas.live

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
