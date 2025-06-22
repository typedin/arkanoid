local StateMachine = {}

StateMachine.__index = StateMachine

---@param states StateMachineStateMap
function StateMachine:new(states)
    local sm = {
        states = states,
        currentState = {},
    }

    setmetatable(sm, StateMachine)

    return sm
end

---@param state string
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
