local Score = {}

function Score:toTable(score)
    local result = { 0, 0, 0, 0, 0, 0 }
    local str = tostring(score)

    for i = 1, #str do
        result[6 - #str + i] = tonumber(str:sub(i, i))
    end

    return result
end

return Score
