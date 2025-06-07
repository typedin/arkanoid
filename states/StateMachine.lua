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

function StateMachine:update(owner, dt)
    if self.currentState and self.currentState.update then
        self.currentState:update(owner, dt)
    end
end

return StateMachine
