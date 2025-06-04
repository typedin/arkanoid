local shallowCopy = function(t1)
    local t2 = {}
    for k, v in pairs(t1) do
        t2[k] = v
    end
    return t2
end

return shallowCopy
