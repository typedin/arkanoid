local Config = require("config.main")

describe("Config", function()
    it("should define paddle properties", function()
        assert.are.equal(300, Config.paddle.x)
        assert.are.equal(400, Config.paddle.speed)
        assert.are.equal(20, Config.paddle.height)
    end)

    it("should define ball initial state", function()
        assert.are.equal(350, Config.ball.x)
        assert.are.equal(10, Config.ball.radius)
        assert.are.equal(-200, Config.ball.dy)
    end)

    it("should define wall thickness", function()
        assert.are.equal(10, Config.layout.wall.thickness)
    end)

    it("should define resolution", function()
        assert.are.equal(1060, Config.layout.resolution.width)
        assert.are.equal(800, Config.layout.resolution.height)
    end)

    it("should define a gold brick as indestructible", function()
        local gold = Config.layout.bricks.kinds.gold
        assert.are.equal(math.huge, gold.hits)
        assert.are.equal(0, gold.points)
    end)

    it("should compute live.pos_x based on wall_left", function()
        local expected = Config.layout.wall_left.x + Config.layout.wall.thickness
        assert.are.equal(expected, Config.layout.live.pos_x)
    end)

    it("should define areas for live and hud", function()
        assert.are.equal(660, Config.layout.area.live.width)
        assert.are.equal(400, Config.layout.area.hud.width)
    end)
end)
