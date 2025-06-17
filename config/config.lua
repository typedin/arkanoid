local ball = require("config.ball")
local paddle = require("config.paddle")
local wall = require("config.wall")

local Config = {}

Config.__index = Config

function Config:new()
    local instance = {
        layout = {
            areas = {
                live = {},
                hud = {},
            },
            ball = ball,
            paddle = paddle,
        },
    }

    setmetatable(instance, Config)

    return instance
end

function Config:apply_resolution(resolution)
    local outer_live_area_width = 660 -- WARNING magic number here

    self.layout.resolution = resolution
    -- defining the outer bounds od the areas
    self.layout.areas.live = {
        x = wall.thickness,
        y = wall.thickness,
        width = outer_live_area_width - (wall.thickness * 2),
        height = self.layout.resolution.height - wall.thickness,
    }
    -- just the rest of the avaible space
    self.layout.areas.hud = {
        x = 660,
        y = 0,
        width = self.layout.resolution.width - outer_live_area_width,
        height = self.layout.resolution.height,
    }
    return self
end

return Config
