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
        update = function(_, ball, context)
            if ball.x + ball.radius / 2 > context.layout.wall_right.x - context.layout.wall_right.thickness then
                ball:invert("dx")
            end
            if ball.x - ball.radius / 2 < context.layout.wall_left.x + context.layout.wall_left.thickness then
                ball:invert("dx")
            end
            if ball.y + ball.radius / 2 < context.layout.wall_up.y + context.layout.wall_up.thickness then
                ball:invert("dy")
            end
            ball:move(context.dt)
        end,
        exit = function() end,
    },
}

return ball_states
