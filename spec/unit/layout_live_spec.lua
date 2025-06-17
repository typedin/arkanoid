local geometry = require("config/geometry")
local live_area = require("config/main").layout.area.live

describe("Layout live", function()
    it("should define the live area outer geometry", function()
        -- There's no need to link walls and live area
        -- they can be computed independently
        local outer_geometry = geometry.get_geometry(live_area)

        assert.are.equal(0, outer_geometry.top)
        assert.are.equal(0, outer_geometry.left)
        assert.are.equal(660, outer_geometry.right)
        assert.are.equal(800, outer_geometry.bottom)
    end)
end)
