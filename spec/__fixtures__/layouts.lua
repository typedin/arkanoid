local layout_fixture = {
    screen = { width = 800, height = 600 },
    resolution = { width = 400, height = 300 },
    layout = {
        areas = {
            active = { x = 0, y = 0, width = 800, height = 600 },
            live = { x = 10, y = 10, width = 480, height = 590, paddle_line = 600, life_line = 565 },
            walls = {
                left = { x = 0, y = 0, width = 10, height = 600, thickness = 10 },
                right = { x = 490, y = 0, width = 10, height = 600, thickness = 10 },
                top = { x = 0, y = 0, width = 500, height = 10, thickness = 10 },
            },
            hud = {
                x = 510,
                y = 0,
                width = 290,
                height = 600,
                subsections = {
                    title =      { x = 510, y = 0,   width = 290, height = 75 },
                    player_1 =   { x = 510, y = 75,  width = 290, height = 75 },
                    player_2 =   { x = 510, y = 150, width = 290, height = 75 },
                    high_score = { x = 510, y = 225, width = 290, height = 75 },
                    credits =    { x = 510, y = 300, width = 290, height = 300 },
                },
            },
        },
        ball = { diameter = 16, radius = 8 },
        bonus = { width = 32, height = 16 },
        brick = { width = 32, height = 16 },
        life = { width = 32, height = 12 },
        paddle = { width = 64, height = 16 },
        wall = { thickness = 10 },
    },
}

return layout_fixture
