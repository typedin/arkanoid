local entities = require("config.geometry.entities")

-- Scale entity dimensions based on screen size and resolution
local function apply_scale(params, entity)
    -- Calculate scale factors
    local screen_scale_x = params.screen.width / params.resolution.width
    local screen_scale_y = params.screen.height / params.resolution.height
    local scale_factor = math.min(screen_scale_x, screen_scale_y) -- Use the smaller scale to maintain aspect ratio

    local scaled_entity = {}
    -- Scale all numeric properties
    for key, value in pairs(entity) do
        if type(value) == "number" then
            scaled_entity[key] = math.floor(value * scale_factor)
        else
            scaled_entity[key] = value -- Keep non-numeric values as-is
        end
    end

    return scaled_entity
end

local Config = {}

Config.__index = Config

---Creates a new Config instance with scaled entities based on screen and resolution
---@class ConfigParams
---@field screen Screen
---@field resolution Resolution

---@return Config
function Config:new(params)
    assert(params.screen, "Config:new requires a params table with a screen property")
    assert(type(params.screen.width) == "number", "Config:new requires screen width")
    assert(type(params.screen.height) == "number", "Config:new requires screen height to be numbers")
    assert(params.resolution, "Config:new requires a params table with a resolution property")
    assert(type(params.resolution.width) == "number", "Config:new requires resolution width")
    assert(type(params.resolution.height) == "number", "Config:new requires resolution height to be numbers")

    local instance = {
        screen = params.screen,
        resolution = params.resolution,
        layout = {
            areas = {
                active = {},
                live = {},
                hud = {},
                walls = {},
            },
            ball = apply_scale(params, entities.ball),
            bonus = apply_scale(params, entities.bonus),
            brick = apply_scale(params, entities.brick),
            life = apply_scale(params, entities.life),
            paddle = apply_scale(params, entities.paddle),
            wall = apply_scale(params, entities.wall),
        },
    }

    setmetatable(instance, Config)
    instance:_apply_resolution()

    return instance
end

---Applies resolution calculations to set up letterboxing and layout areas
---@return Config
function Config:_apply_resolution()
    local resolution_aspect = self.resolution.width / self.resolution.height

    -- Always use full screen width
    local active_width = self.screen.width
    -- Calculate height based on resolution aspect ratio
    local active_height = active_width / resolution_aspect
    -- Center horizontally (always 0 since we use full width)
    local active_x = 0
    -- Center vertically if needed
    local active_y = (self.screen.height - active_height) / 2

    self.layout.areas.active = {
        width = math.floor(active_width),
        height = math.floor(active_height),
        x = math.floor(active_x),
        y = math.floor(active_y),
    }

    -- defining the outer bounds of the areas
    -- The live area is 62% of the available screen
    local LIVE_RATIO = 0.62
    self.layout.areas.live = {
        x = self.layout.areas.active.x + self.layout.wall.thickness,
        y = self.layout.areas.active.y + self.layout.wall.thickness,
        width = math.floor(LIVE_RATIO * self.layout.areas.active.width) - (self.layout.wall.thickness * 2),
        height = self.layout.areas.active.height - self.layout.wall.thickness,
        paddle_line = self.layout.areas.active.height - self.layout.wall.thickness + 10,
    }
    self.layout.areas.walls = {
        left = {
            x = self.layout.areas.active.x,
            y = self.layout.areas.active.y,
            width = self.layout.wall.thickness,
            height = self.layout.areas.active.height,
            thickness = self.layout.wall.thickness,
        },
        right = {
            x = self.layout.areas.live.x + self.layout.areas.live.width,
            y = self.layout.areas.active.y,
            width = self.layout.wall.thickness,
            height = self.layout.areas.active.height,
            thickness = self.layout.wall.thickness,
        },
        top = {
            x = self.layout.areas.active.x,
            y = self.layout.areas.active.y,
            width = self.layout.areas.live.width + (self.layout.wall.thickness * 2),
            height = self.layout.wall.thickness,
            thickness = self.layout.wall.thickness,
        },
    }

    -- just the rest of the available space
    self.layout.areas.hud = {
        x = self.layout.areas.live.width + self.layout.wall.thickness,
        y = self.layout.areas.active.y,
        width = self.layout.areas.active.width - self.layout.areas.live.width - self.layout.wall.thickness * 2,
        height = self.layout.areas.active.height,
    }
    return self
end

return Config
