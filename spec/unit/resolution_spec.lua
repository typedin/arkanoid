local resolutions = require("config.resolutions")
local Config = require("config.config")

describe("Resolution", function()
    it("sould define areas on Config", function()
        -- width = 1060,
        -- height = 800,
        local config = Config:new()
        config:apply_resolution(resolutions[1])

        assert.are.equal(1060, config.layout.resolution.width)
        assert.are.equal(800, config.layout.resolution.height)

        -- assert that walls are not part of the live area
        assert.are.equal(10, config.layout.areas.live.x)
        assert.are.equal(10, config.layout.areas.live.y)
        assert.are.equal(640, config.layout.areas.live.width)
        assert.are.equal(790, config.layout.areas.live.height)

        assert.are.equal(660, config.layout.areas.hud.x)
        assert.are.equal(0, config.layout.areas.hud.y)
        assert.are.equal(400, config.layout.areas.hud.width)
        assert.are.equal(800, config.layout.areas.hud.height)
    end)

    it("should define paddle", function()
        -- width = 1060,
        -- height = 800,
        local config = Config:new()
        config:apply_resolution(resolutions[1])

        -- width = 100,
        -- height = 20,
        -- x = 300,
        -- y = 700,
        assert.are.equal(100, config.layout.paddle.width)
        assert.are.equal(20, config.layout.paddle.height)
        assert.are.equal(300, config.layout.paddle.x)
        assert.are.equal(700, config.layout.paddle.y)
    end)

    it("should define a ball", function()
        -- width = 1060,
        -- height = 800,
        local config = Config:new()
        config:apply_resolution(resolutions[1])

        -- x = 350,
        -- y = 700 - 20,
        -- radius = 10,
        assert.are.equal(350, config.layout.ball.x)
        assert.are.equal(680, config.layout.ball.y)
        assert.are.equal(10, config.layout.ball.radius)
    end)
end)
