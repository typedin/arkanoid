local Config = {
    paddle = {
        x = 300,
        y = 700,
        width = 100,
        height = 20,
        speed = 400,
    },
    ball = {
        x = 350,
        y = 700 - 20,
        radius = 10,
        dx = 200,
        dy = -200,
    },
    layout = {
        wall = {
            thickness = 10,
        },
        wall_left = {
            thickness = 10,
            width = 0,
            height = 800,
            x = 0,
            y = 0,
        },
        wall_up = {
            thickness = 10,
            width = 655,
            height = 0,
            x = 0,
            y = 0,
        },
        wall_right = {
            thickness = 10,
            width = 0,
            height = 800,
            x = 655,
            y = 0,
        },
        resolution = {
            width = 1060,
            height = 800,
        },
        bricks = {
            rows = 5,
            cols = 10,
            width = 60,
            height = 20,
            margin = 5,
        },
    },
}

Config.layout.live = {
    pos_x = Config.layout.wall_left.x + Config.layout.wall_left.thickness,
    pos_y = Config.layout.resolution.height - 20,
    margin_right = 60,
    width = 50,
    height = 10,
}

Config.paddle = {
    x = 300,
    y = 700,
    width = 100,
    height = 20,
    speed = 400,
}

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
