local Score = {}
Score.__index = Score

---@class ScoreParams
---@field x number
---@field y number
---@field width number
---@field height number
---@field player_name string

---@return Score
function Score:new(params)
    -- assert all fields are the right type
    assert(type(params.x) == "number", "Score:new requires params.x to be a number")
    assert(type(params.y) == "number", "Score:new requires params.y to be a number")
    assert(type(params.width) == "number", "Score:new requires params.width to be a number")
    assert(type(params.height) == "number", "Score:new requires params.height to be a number")
    assert(type(params.player_name) == "string", "Score:new requires params.player_name to be a string")

    local instance = {
        value = 0,
        x = params.x,
        y = params.y,
        width = params.width,
        height = params.height,
        player_name = params.player_name,
    }

    setmetatable(instance, Score)

    return instance
end

function Score:add(points)
    assert(type(points) == "number", "Score:add requires a number")
    self.value = self.value + points
end

function Score:toTable()
    assert(self.value ~= nil, "Score value is nil - was Score:new() called?")
    local result = { 0, 0, 0, 0, 0, 0 }
    local str = tostring(self.value)
    for i = 1, #str do
        result[6 - #str + i] = tonumber(str:sub(i, i))
    end

    return result
end

function Score:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.print(self.player_name, self.x + 4, self.y)
    local score_table = self:toTable()
    for i = 1, #score_table do
        love.graphics.print(score_table[i], self.x + 4 + (10 * i), self.y + 16)
    end
end

return Score
