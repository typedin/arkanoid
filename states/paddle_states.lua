---@type StateMachineStateMap
local paddle_states = {
    idle = {
        enter = function() end,
        update = function() end,
        exit = function() end,
    },
    moving_left = {
        enter = function() end,
        ---@param paddle Paddle
        ---@param context { dt: number, layout: Layout }
        update = function(_, paddle, context)
            paddle:move_left(context)
        end,
        exit = function() end,
    },
    moving_right = {
        enter = function() end,
        ---@param paddle Paddle
        ---@param context { dt: number, layout: Layout }
        update = function(_, paddle, context)
            paddle:move_right(context)
        end,
        exit = function() end,
    },
}

return paddle_states
