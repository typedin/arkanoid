local function parse_args()
    local args = {}
    for i, v in ipairs(arg) do
        -- Only parse after the '--' separator (LOVE passes the script path and other stuff before)
        if v == "--" then
            for j = i + 1, #arg do
                local pair = arg[j]
                local key, value = pair:match("([^=]+)=(.+)")
                if key and value then
                    -- Support comma-separated lists
                    if value:find(",") then
                        local list = {}
                        for item in value:gmatch("[^,]+") do
                            table.insert(list, item)
                        end
                        args[key] = list
                    else
                        args[key] = value
                    end
                else
                    args[pair] = true -- flags like --debug
                end
            end
            break
        end
    end
    return args
end

return parse_args
