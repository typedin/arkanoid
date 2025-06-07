---@class StateMachine
---@field states StateMachineStateMap
---@field currentState StateMachineState
---@field new fun(states: StateMachineStateMap)
---@field change fun(state: string)
---@field update fun(owner: table, dt: number)

local StateMachine = {}

StateMachine.__index = StateMachine

function StateMachine:new(states)
    local sm = {
        states = states,
        currentState = {},
    }

    setmetatable(sm, StateMachine)

    return sm
end

function StateMachine:change(state)
    if self.currentState and self.currentState.exit then
        self.currentState:exit()
    end

    self.currentState = self.states[state]

    if self.currentState and self.currentState.enter then
        self.currentState:enter()
    end
end

function StateMachine:update(owner, context)
    if self.currentState and self.currentState.update then
        self.currentState:update(owner, context)
    end
end

return StateMachine
