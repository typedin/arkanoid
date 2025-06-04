local shallowCopy = require("libraries/shallow_copy")
local paddle = require("config/main").paddle

local Paddle = {}

function Paddle:new()
    return shallowCopy(paddle)
end

return Paddle
