---@diagnostic disable: undefined-field
local resolutions = require("config.resolutions")
local Layout = require("config.layout")

describe("Layout", function()
    describe("letterboxing", function()
        it("should define an area with the correct letterboxing for 320x240", function()
            -- width = 320,
            -- height = 256,
            local layout = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            assert.are.equal(320, layout.layout.areas.active.width)
            assert.are.equal(200, layout.layout.areas.active.height)
            assert.are.equal(0, layout.layout.areas.active.x)
            assert.are.equal(20, layout.layout.areas.active.y)
        end)

        it("should handle letterboxing when screen is wider than resolution", function()
            local layout = Layout:new({ resolution = resolutions["amiga"], screen = { width = 640, height = 480 } })

            assert.are.equal(640, layout.layout.areas.active.width)
            assert.are.equal(400, layout.layout.areas.active.height)
            assert.are.equal(0, layout.layout.areas.active.x)
            assert.are.equal(40, layout.layout.areas.active.y)
        end)

        it("should handle letterboxing when screen is taller than resolution", function()
            local layout = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 400 } })

            assert.are.equal(320, layout.layout.areas.active.width)
            assert.are.equal(200, layout.layout.areas.active.height)
            assert.are.equal(0, layout.layout.areas.active.x)
            assert.are.equal(100, layout.layout.areas.active.y)
        end)

        it("should handle letterboxing for C64 resolution on square screen", function()
            local layout = Layout:new({ resolution = resolutions["c64"], screen = { width = 800, height = 800 } })

            assert.are.equal(800, layout.layout.areas.active.width)
            assert.are.equal(500, layout.layout.areas.active.height)
            assert.are.equal(0, layout.layout.areas.active.x)
            assert.are.equal(150, layout.layout.areas.active.y)
        end)

        it("should handle letterboxing for Atari ST resolution on mobile screen", function()
            local layout = Layout:new({ resolution = resolutions["atari_st"], screen = { width = 375, height = 812 } })

            assert.are.equal(375, layout.layout.areas.active.width)
            assert.are.equal(234, layout.layout.areas.active.height)
            assert.are.equal(0, layout.layout.areas.active.x)
            assert.are.equal(288, layout.layout.areas.active.y)
        end)

        it("should handle letterboxing when screen and resolution have same aspect ratio", function()
            local layout = Layout:new({ resolution = resolutions["amiga"], screen = { width = 640, height = 400 } })

            assert.are.equal(640, layout.layout.areas.active.width)
            assert.are.equal(400, layout.layout.areas.active.height)
            assert.are.equal(0, layout.layout.areas.active.x)
            assert.are.equal(0, layout.layout.areas.active.y)
        end)

        it("should handle letterboxing for NES resolution on modern screen", function()
            local layout = Layout:new({ resolution = resolutions["nes"], screen = { width = 1920, height = 1080 } })

            assert.are.equal(1920, layout.layout.areas.active.width)
            assert.are.equal(1800, layout.layout.areas.active.height)
            assert.are.equal(0, layout.layout.areas.active.x)
            assert.are.equal(-360, layout.layout.areas.active.y)
        end)

        it("should handle letterboxing for SNES resolution on modern screen", function()
            local layout = Layout:new({ resolution = resolutions["snes"], screen = { width = 1920, height = 1080 } })

            assert.are.equal(1920, layout.layout.areas.active.width)
            assert.are.equal(1680, layout.layout.areas.active.height)
            assert.are.equal(0, layout.layout.areas.active.x)
            assert.are.equal(-300, layout.layout.areas.active.y)
        end)

        it("should handle letterboxing for default resolution on 4K screen", function()
            local layout = Layout:new({ resolution = resolutions["default"], screen = { width = 3840, height = 2160 } })

            assert.are.equal(3840, layout.layout.areas.active.width)
            assert.are.equal(2400, layout.layout.areas.active.height)
            assert.are.equal(0, layout.layout.areas.active.x)
            assert.are.equal(-120, layout.layout.areas.active.y)
        end)

        it("should handle letterboxing for VGA DOS resolution on ultrawide screen", function()
            local layout = Layout:new({ resolution = resolutions["vga_dos"], screen = { width = 3440, height = 1440 } })

            assert.are.equal(3440, layout.layout.areas.active.width)
            assert.are.equal(2150, layout.layout.areas.active.height)
            assert.are.equal(0, layout.layout.areas.active.x)
            assert.are.equal(-355, layout.layout.areas.active.y)
        end)
    end)

    describe("hud area", function()
        it("should define a hud area", function()
            local layout = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            -- add the wall thickness
            assert.are.equal(190, layout.layout.areas.hud.x)
            assert.are.equal(20, layout.layout.areas.hud.y)
            assert.are.equal(200, layout.layout.areas.hud.height) -- screen size minus 40 px
            assert.are.equal(320 - 198, layout.layout.areas.hud.width)
        end)

        it("should have 5 subsections", function()
            local hud = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } }).layout.areas.hud

            local keyset = {}
            for k, _ in pairs(hud.subsections) do
                keyset[#keyset + 1] = k
            end
            assert.are.equal(5, #keyset)
        end)

        it("should define the same width for all subsections", function()
            local hud = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } }).layout.areas.hud

            for _, subsection in pairs(hud.subsections) do
                assert.are.equal(hud.width, subsection.width)
            end
        end)

        it("should define the same height for title, player_1, player_2 and high_score", function()
            local hud = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } }).layout.areas.hud

            assert.are.equal(
                hud.height / 2,
                hud.subsections.title.height + hud.subsections.player_1.height + hud.subsections.player_2.height + hud.subsections.high_score.height
            )
            assert.are.equal(hud.height / 2, hud.subsections.credits.height)
        end)
    end)

    describe("live areas", function()
        it("should define a live area this is 62% of the active area", function()
            local layout = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            -- assert that walls are not part of the live area
            -- 8 is wall thickness
            assert.are.equal(8, layout.layout.areas.live.x)
            assert.are.equal(20 + 8, layout.layout.areas.live.y)
            assert.are.equal(200 - 8, layout.layout.areas.live.height) -- screen size minus 40 px
            assert.are.equal(182, layout.layout.areas.live.width)
            assert.are.equal(202, layout.layout.areas.live.paddle_line)
        end)
    end)

    it("should define walls", function()
        -- width = 320,
        -- height = 256,
        local layout = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

        assert(3, #layout.layout.areas.walls)
        -- left
        -- WARNING letterboxing
        assert.are.equal(0, layout.layout.areas.walls.left.x)
        assert.are.equal(20, layout.layout.areas.walls.left.y)
        assert.are.equal(200, layout.layout.areas.walls.left.height)
        assert.are.equal(8, layout.layout.areas.walls.left.width)
        assert.are.equal(8, layout.layout.areas.walls.left.thickness)
        -- right
        assert.are.equal(190, layout.layout.areas.walls.right.x)
        assert.are.equal(20, layout.layout.areas.walls.right.y)
        assert.are.equal(8, layout.layout.areas.walls.right.width)
        assert.are.equal(200, layout.layout.areas.walls.right.height)
        assert.are.equal(8, layout.layout.areas.walls.left.thickness)
        -- top
        assert.are.equal(0, layout.layout.areas.walls.top.x)
        assert.are.equal(20, layout.layout.areas.walls.top.y)
        assert.are.equal(198, layout.layout.areas.walls.top.width)
        assert.are.equal(8, layout.layout.areas.walls.top.height)
        assert.are.equal(8, layout.layout.areas.walls.left.thickness)
    end)

    describe("entities", function()
        it("should define the paddle", function()
            local layout = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            assert.are.equal(layout.layout.paddle.width, 32)
            assert.are.equal(layout.layout.paddle.height, 8)
        end)
        it("should define the ball", function()
            local layout = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            assert.are.equal(layout.layout.ball.diameter, 4)
        end)
        it("should define the brick", function()
            local layout = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            assert.are.equal(layout.layout.brick.width, 16) -- let the sprite display a padding
            assert.are.equal(layout.layout.brick.height, 8)
        end)
        it("should define the life", function()
            local layout = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            assert.are.equal(layout.layout.life.width, 16)
            assert.are.equal(layout.layout.life.height, 6)
        end)
        it("should define the bonus", function()
            local layout = Layout:new({ resolution = resolutions["amiga"], screen = { width = 320, height = 240 } })

            assert.are.equal(layout.layout.bonus.width, 16)
            assert.are.equal(layout.layout.bonus.height, 8)
        end)
    end)
end)
