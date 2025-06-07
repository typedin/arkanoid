---@class StateMachineState
---@field enter fun(self:StateMachineState, entity:any, dt:number)
---@field update fun(self:StateMachineState, entity:any, dt:number)
---@field exit fun(self:StateMachineState, entity:any, dt:number)

---@alias StateMachineStateMap table<string, StateMachineState>
