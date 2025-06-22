---@diagnostic disable: undefined-field
local Players = require("config.players")

describe("Player", function()
    it("default to one", function()
        local players = Players:create({ players = { { name = "me" } } })

        assert.are.equal(1, #players)
        assert.are.equal("me", players[1].name)
        assert.are.equal(3, players[1].lives)
        assert.are.equal(1, players[1].current_level)
        assert.are.equal(0, players[1].score)
    end)

    it("can build 2 players", function()
        local players = Players:create({ players = { { name = "me" }, { name = "you" } } })

        assert.are.equal(2, #players)
        assert.are.equal("me", players[1].name)
        assert.are.equal(3, players[1].lives)
        assert.are.equal("you", players[2].name)
        assert.are.equal(3, players[2].lives)
    end)
end)
