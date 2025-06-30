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

local Layout = {}

Layout.__index = Layout

---Creates a new Layout instance with scaled entities based on screen and resolution
---@class LayoutParams
---@field screen Screen
---@field resolution Resolution

---@return Layout
function Layout:new(params)
    assert(params.screen, "Layout Layout:new requires a params table with a screen property")
    assert(type(params.screen.width) == "number", "Layout:new requires screen width")
    assert(type(params.screen.height) == "number", "Layout:new requires screen height to be numbers")
    assert(params.resolution, "Layout:new requires a params table with a resolution property")
    assert(type(params.resolution.width) == "number", "Layout:new requires resolution width")
    assert(type(params.resolution.height) == "number", "Layout:new requires resolution height to be numbers")

    local instance = {
        screen = params.screen,
        resolution = params.resolution,
        layout = {
            areas = {},
            ball = apply_scale(params, entities.ball),
            bonus = apply_scale(params, entities.bonus),
            brick = apply_scale(params, entities.brick),
            laser = apply_scale(params, entities.laser),
            life = apply_scale(params, entities.life),
            paddle = apply_scale(params, entities.paddle),
            power_up = apply_scale(params, entities.power_up),
            wall = apply_scale(params, entities.wall),
        },
    }

    setmetatable(instance, Layout)

    -- use methods to clean up the code
    instance:_apply_resolution()
    instance:_build_hud()

    return instance
end

---Applies resolution calculations to set up letterboxing and layout areas
---@return Layout
function Layout:_apply_resolution()
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
    local LIFE_OFFSET = 25
    self.layout.areas.live = {
        x = self.layout.areas.active.x + self.layout.wall.thickness,
        y = self.layout.areas.active.y + self.layout.wall.thickness,
        width = math.floor(LIVE_RATIO * self.layout.areas.active.width) - (self.layout.wall.thickness * 2),
        height = self.layout.areas.active.height - self.layout.wall.thickness,
        paddle_line = self.layout.areas.active.height - self.layout.wall.thickness + 10,
        life_line = self.layout.areas.active.height + LIFE_OFFSET,
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
        x = self.layout.areas.live.width + self.layout.wall.thickness + self.layout.wall.thickness,
        y = self.layout.areas.active.y,
        width = self.layout.areas.active.width - self.layout.areas.live.width - self.layout.wall.thickness * 2,
        height = self.layout.areas.active.height,
    }

    return self
end

function Layout:_build_hud()
    self.layout.areas.hud.subsections = {
        title = {},
        player_1 = {},
        player_2 = {},
        high_score = {},
        credits = {},
    }

    -- List of subsection names that use the same width/height logic
    local simple_sections = { "title", "player_1", "player_2", "high_score" }
    for index, name in ipairs(simple_sections) do
        self.layout.areas.hud.subsections[name].x = self.layout.areas.hud.x
        self.layout.areas.hud.subsections[name].y = self.layout.areas.hud.y + self.layout.areas.hud.height / 8 * (index - 1)
        self.layout.areas.hud.subsections[name].width = self.layout.areas.hud.width
        -- each subsection is 1/8 of the hud height
        self.layout.areas.hud.subsections[name].height = self.layout.areas.hud.height / 8
    end

    -- Special case for credits
    self.layout.areas.hud.subsections.credits.width = self.layout.areas.hud.width
    self.layout.areas.hud.subsections.credits.height = self.layout.areas.hud.height / 2
    self.layout.areas.hud.subsections.credits.y = self.layout.areas.hud.y + self.layout.areas.hud.height / 2
    self.layout.areas.hud.subsections.credits.x = self.layout.areas.hud.x

    return self
end
return Layout
