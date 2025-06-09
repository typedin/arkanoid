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
            width = 60,
            height = 20,
            margin = 2,
            kinds = {
                gray = {
                    hits = 1,
                    points = 50,
                    rgb = { 128, 128, 128 },
                },
                red = {
                    hits = 1,
                    points = 60,
                    rgb = { 255, 8, 0 },
                },
                orange = {
                    hits = 1,
                    points = 70,
                    rgb = { 255, 88, 0 },
                },
                yellow = {
                    hits = 1,
                    points = 80,
                    rgb = { 255, 255, 51 },
                },
                green = {
                    hits = 1,
                    points = 90,
                    rgb = { 102, 255, 0 },
                },
                blue = {
                    hits = 1,
                    points = 100,
                    rgb = { 0, 72, 186 },
                },
                purple = {
                    hits = 1,
                    points = 110,
                    rgb = { 191, 0, 255 },
                },
                white = {
                    hits = 1,
                    points = 120,
                    rgb = { 255, 255, 255 },
                },
                cyan = {
                    hits = 1,
                    points = 130,
                    rgb = { 0, 255, 255 },
                },
                silver = {
                    hits = 2,
                    points = 150,
                    rgb = { 117, 117, 117 },
                },
                gold = {
                    hits = math.huge, -- indestructible
                    points = 0,
                    rgb = { 255, 215, 0 },
                },
            },
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
