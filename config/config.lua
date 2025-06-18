local entities = require("config.entities")
local Config = {}

Config.__index = Config

function Config:new(params)
    if not params.screen then
        error("Config:new requires a params table with a screen property")
    end
    if type(params.screen.width) ~= "number" then
        error("Config:new requires screen width")
    end
    if type(params.screen.height) ~= "number" then
        error("Config:new requires screen height to be numbers")
    end
    if not params or not params.resolution then
        error("Config:new requires a params table with a resolution property")
    end
    if type(params.resolution.width) ~= "number" then
        error("Config:new requires resolution width")
    end
    if type(params.resolution.height) ~= "number" then
        error("Config:new requires resolution height to be numbers")
    end

    local instance = {
        screen = params.screen,
        resolution = params.resolution,
        layout = {
            areas = {
                active = {},
                live = {},
                hud = {},
            },
            ball = entities.ball,
            paddle = entities.paddle,
            brick = entities.brick,
            life = entities.life,
            bonus = entities.bonus,
        },
    }

    setmetatable(instance, Config)

    instance:_apply_resolution()

    return instance
end

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
    -- The live area is 62% of the avaible screen
    local LIVE_RATIO = 0.62
    self.layout.areas.live = {
        x = self.layout.areas.active.x + entities.wall.thickness,
        y = self.layout.areas.active.y + entities.wall.thickness,
        width = math.floor(LIVE_RATIO * self.layout.areas.active.width) - (entities.wall.thickness * 2),
        height = self.layout.areas.active.height - entities.wall.thickness,
    }

    self.layout.areas.walls = {
        left = {
            x = self.layout.areas.active.x,
            y = self.layout.areas.active.y,
            width = entities.wall.thickness,
            height = self.layout.areas.active.height,
        },
        right = {
            x = self.layout.areas.live.x + self.layout.areas.live.width,
            y = self.layout.areas.active.y,
            width = entities.wall.thickness,
            height = self.layout.areas.active.height,
        },
        top = {
            x = self.layout.areas.active.x,
            y = self.layout.areas.active.y,
            width = self.layout.areas.live.width + (entities.wall.thickness * 2),
            height = entities.wall.thickness,
        },
    }

    -- just the rest of the available space
    self.layout.areas.hud = {
        x = self.layout.areas.live.width + entities.wall.thickness,
        y = self.layout.areas.active.y,
        width = self.layout.areas.active.width - self.layout.areas.live.width - entities.wall.thickness * 2,
        height = self.layout.areas.active.height,
    }
    return self
end

return Config
