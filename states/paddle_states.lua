local paddle_states = {
    idle = {
        enter = function() end,
        update = function() end,
        exit = function() end,
    },
    moving_left = {
        enter = function() end,
        update = function(_, paddle, dt)
            paddle:move_left(dt)
        end,
        exit = function() end,
    },
    moving_right = {
        enter = function() end,
        update = function(_, paddle, dt)
            paddle:move_right(dt)
        end,
        exit = function() end,
    },
}

return paddle_states
