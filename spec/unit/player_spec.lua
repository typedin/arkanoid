---@diagnostic disable: undefined-field
local Config = require("config.config")
local resolution = require("config.resolutions")["amiga"]
local screen = { width = 320, height = 240 }

describe("Player", function()
    it("default to one", function()
        local config = Config:new({ players = { { name = "me" } }, resolution = resolution, screen = screen })

        assert.are.equal(1, #config.players)
        assert.are.equal("me", config.players[1].name)
        assert.are.equal(3, config.players[1].lives)
    end)

    it("can build 2 players", function()
        local config = Config:new({ players = { { name = "me" }, { name = "you" } }, resolution = resolution, screen = screen })

        assert.are.equal(2, #config.players)
        assert.are.equal("me", config.players[1].name)
        assert.are.equal(3, config.players[1].lives)
        assert.are.equal("you", config.players[2].name)
        assert.are.equal(3, config.players[2].lives)
    end)
end)
