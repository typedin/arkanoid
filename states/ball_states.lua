---@type StateMachineStateMap
local ball_states = {
    idle = {
        enter = function() end,
        update = function() end,
        exit = function() end,
    },
    moving = {
        enter = function() end,
        ---@param ball Ball
        ---@param context { dt: number, layout: Layout }
        update = function(_, ball, context) end,
        exit = function() end,
    },
}

return ball_states
