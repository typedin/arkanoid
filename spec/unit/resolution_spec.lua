local resolutions = require("config.resolutions")
local Config = require("config.config")

describe("Resolution", function()
    describe("letterboxing", function()
        it("should define an area with the correct letterboxing for 320x240", function()
            -- width = 320,
            -- height = 256,
            local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            assert.are.equal(320, config.layout.areas.active.width)
            assert.are.equal(200, config.layout.areas.active.height)
            assert.are.equal(0, config.layout.areas.active.x)
            assert.are.equal(20, config.layout.areas.active.y)
        end)

        it("should handle letterboxing when screen is wider than resolution", function()
            local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 640, height = 480 } })

            assert.are.equal(640, config.layout.areas.active.width)
            assert.are.equal(400, config.layout.areas.active.height)
            assert.are.equal(0, config.layout.areas.active.x)
            assert.are.equal(40, config.layout.areas.active.y)
        end)

        it("should handle letterboxing when screen is taller than resolution", function()
            local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 400 } })

            assert.are.equal(320, config.layout.areas.active.width)
            assert.are.equal(200, config.layout.areas.active.height)
            assert.are.equal(0, config.layout.areas.active.x)
            assert.are.equal(100, config.layout.areas.active.y)
        end)

        it("should handle letterboxing for C64 resolution on square screen", function()
            local config = Config:new({ resolution = resolutions["c64"], screen = { width = 800, height = 800 } })

            assert.are.equal(800, config.layout.areas.active.width)
            assert.are.equal(500, config.layout.areas.active.height)
            assert.are.equal(0, config.layout.areas.active.x)
            assert.are.equal(150, config.layout.areas.active.y)
        end)

        it("should handle letterboxing for Atari ST resolution on mobile screen", function()
            local config = Config:new({ resolution = resolutions["atari_st"], screen = { width = 375, height = 812 } })

            assert.are.equal(375, config.layout.areas.active.width)
            assert.are.equal(234, config.layout.areas.active.height)
            assert.are.equal(0, config.layout.areas.active.x)
            assert.are.equal(288, config.layout.areas.active.y)
        end)

        it("should handle letterboxing when screen and resolution have same aspect ratio", function()
            local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 640, height = 400 } })

            assert.are.equal(640, config.layout.areas.active.width)
            assert.are.equal(400, config.layout.areas.active.height)
            assert.are.equal(0, config.layout.areas.active.x)
            assert.are.equal(0, config.layout.areas.active.y)
        end)

        it("should handle letterboxing for NES resolution on modern screen", function()
            local config = Config:new({ resolution = resolutions["nes"], screen = { width = 1920, height = 1080 } })

            assert.are.equal(1920, config.layout.areas.active.width)
            assert.are.equal(1800, config.layout.areas.active.height)
            assert.are.equal(0, config.layout.areas.active.x)
            assert.are.equal(-360, config.layout.areas.active.y)
        end)

        it("should handle letterboxing for SNES resolution on modern screen", function()
            local config = Config:new({ resolution = resolutions["snes"], screen = { width = 1920, height = 1080 } })

            assert.are.equal(1920, config.layout.areas.active.width)
            assert.are.equal(1680, config.layout.areas.active.height)
            assert.are.equal(0, config.layout.areas.active.x)
            assert.are.equal(-300, config.layout.areas.active.y)
        end)

        it("should handle letterboxing for default resolution on 4K screen", function()
            local config = Config:new({ resolution = resolutions["default"], screen = { width = 3840, height = 2160 } })

            assert.are.equal(3840, config.layout.areas.active.width)
            assert.are.equal(2400, config.layout.areas.active.height)
            assert.are.equal(0, config.layout.areas.active.x)
            assert.are.equal(-120, config.layout.areas.active.y)
        end)

        it("should handle letterboxing for VGA DOS resolution on ultrawide screen", function()
            local config = Config:new({ resolution = resolutions["vga_dos"], screen = { width = 3440, height = 1440 } })

            assert.are.equal(3440, config.layout.areas.active.width)
            assert.are.equal(2150, config.layout.areas.active.height)
            assert.are.equal(0, config.layout.areas.active.x)
            assert.are.equal(-355, config.layout.areas.active.y)
        end)
    end)

    describe("hud and live areas", function()
        it("should define a live area this is 62% of the active area", function()
            local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            -- assert that walls are not part of the live area
            -- 8 is wall thickness
            assert.are.equal(8, config.layout.areas.live.x)
            assert.are.equal(20 + 8, config.layout.areas.live.y)
            assert.are.equal(200 - 8, config.layout.areas.live.height) -- screen size minus 40 px
            assert.are.equal(182, config.layout.areas.live.width)
        end)

        it("should define a hud area", function()
            local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            -- add the wall thickness
            assert.are.equal(190, config.layout.areas.hud.x)
            assert.are.equal(20, config.layout.areas.hud.y)
            assert.are.equal(200, config.layout.areas.hud.height) -- screen size minus 40 px
            assert.are.equal(320 - 198, config.layout.areas.hud.width)
        end)
    end)

    it("should define walls", function()
        -- width = 320,
        -- height = 256,
        local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

        assert(3, #config.layout.areas.walls)
        -- left
        -- WARNING letterboxing
        assert.are.equal(0, config.layout.areas.walls.left.x)
        assert.are.equal(20, config.layout.areas.walls.left.y)
        assert.are.equal(200, config.layout.areas.walls.left.height)
        assert.are.equal(8, config.layout.areas.walls.left.width)
        assert.are.equal(8, config.layout.areas.walls.left.thickness)
        -- right
        assert.are.equal(190, config.layout.areas.walls.right.x)
        assert.are.equal(20, config.layout.areas.walls.right.y)
        assert.are.equal(8, config.layout.areas.walls.right.width)
        assert.are.equal(200, config.layout.areas.walls.right.height)
        assert.are.equal(8, config.layout.areas.walls.left.thickness)
        -- top
        assert.are.equal(0, config.layout.areas.walls.top.x)
        assert.are.equal(20, config.layout.areas.walls.top.y)
        assert.are.equal(198, config.layout.areas.walls.top.width)
        assert.are.equal(8, config.layout.areas.walls.top.height)
        assert.are.equal(8, config.layout.areas.walls.left.thickness)
    end)

    describe("entities", function()
        it("should define the paddle", function()
            local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            assert.are.equal(config.layout.paddle.width, 32)
            assert.are.equal(config.layout.paddle.height, 8)
        end)
        it("should define the ball", function()
            local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            assert.are.equal(config.layout.ball.diameter, 4)
        end)
        it("should define the brick", function()
            local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            assert.are.equal(config.layout.brick.width, 16) -- let the sprite display a padding
            assert.are.equal(config.layout.brick.height, 8)
        end)
        it("should define the life", function()
            local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            assert.are.equal(config.layout.life.width, 16)
            assert.are.equal(config.layout.life.height, 6)
        end)
        it("should define the bonus", function()
            local config = Config:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            assert.are.equal(config.layout.bonus.width, 16)
            assert.are.equal(config.layout.bonus.height, 8)
        end)
    end)
end)
