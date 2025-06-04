local shallowCopy = require("libraries/shallow_copy")
local ball = require("config/main").ball

local Ball = {}

function Ball:new()
    return shallowCopy(ball)
end

return Ball
