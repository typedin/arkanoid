---@class LevelFile
local M = {}
M.name = "Level 1"
-- Rows of bricks
M.rows = {
    --[[ row 1 ]]
    -- empty
    {},
    --[[ row 2 ]]
    -- empty
    {},
    --[[ row 3 ]]
    -- empty
    {},
    {
        { kind = "gray", power_up = "E" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray", power_up = "S" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" },
    },
    --[[ row 2 ]]
    {
        { kind = "red" }, { kind = "red", power_up = "U" }, { kind = "red" }, { kind = "red" }, { kind = "red" }, { kind = "red" }, { kind = "red" }, { kind = "red" }, { kind = "red" }, { kind = "red" },  { kind = "red" },{ kind = "red" },{ kind = "red" },
	},
    --[[ row 3 ]]
    {
        { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow", power_up = "D" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" },
	},
    --[[ row 4 ]]
    {
        { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue", power_up = "C" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" },{ kind = "blue" },{ kind = "blue" },
    },
    --[[ row 5 ]]
    {
        { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green", power_up = "L" }, { kind = "green" }, { kind = "green" }, { kind = "green" },{ kind = "green" },{ kind = "green" },
    },
    --[[ row 6 - additional row for remaining power-ups ]]
    {
        { kind = "gray", power_up = "B" }, { kind = "gray", power_up = "M" }, { kind = "gray", power_up = "P" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" },
    },
}

return M
