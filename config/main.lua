local ball = require("config.ball")
local bricks = require("config.bricks")
local paddle = require("config.paddle")
local resolutions = require("config.resolutions")

local Config = {
    layout = {
        wall = {
            thickness = 10,
        },
        wall_left = {
            width = 0,
            height = 800,
            x = 0,
            y = 0,
        },
        wall_up = {
            width = 655,
            height = 0,
            x = 0,
            y = 0,
        },
        wall_right = {
            width = 0,
            height = 800,
            x = 655,
            y = 0,
        },
        resolution = resolutions["default"],
        bricks = bricks,
    },
}

Config.layout.live = {
    pos_x = Config.layout.wall_left.x + Config.layout.wall.thickness,
    pos_y = Config.layout.resolution.height - 20,
    margin_right = 60,
    width = 50,
    height = 10,
}

Config.ball = ball

Config.paddle = paddle

Config.layout.area = {
    live = {
        x = 0,
        y = 0,
        width = 660,
        height = Config.layout.resolution.height,
    },
    hud = {
        x = 660,
        y = 0,
        width = 400,
        height = Config.layout.resolution.height,
    },
}

return Config
