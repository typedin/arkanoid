local merge_table = {}

---Merges the source table into the target table
---@param target table The target table to merge into
---@param source table The source table to merge from
---@return table The modified target table
function merge_table.merge(target, source)
    for key, value in pairs(source) do
        target[key] = value
    end
    return target
end

return merge_table

