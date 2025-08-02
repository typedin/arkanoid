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
        { type = "gray", power_up = "E" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray", power_up = "S" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray" },
    },
    --[[ row 2 ]]
    {
        { type = "red" }, { type = "red", power_up = "U" }, { type = "red" }, { type = "red" }, { type = "red" }, { type = "red" }, { type = "red" }, { type = "red" }, { type = "red" }, { type = "red" },  { type = "red" },{ type = "red" },{ type = "red" },
	},
    --[[ row 3 ]]
    {
        { type = "yellow" }, { type = "yellow" }, { type = "yellow" }, { type = "yellow", power_up = "D" }, { type = "yellow" }, { type = "yellow" }, { type = "yellow" }, { type = "yellow" }, { type = "yellow" }, { type = "yellow" }, { type = "yellow" }, { type = "yellow" }, { type = "yellow" },
	},
    --[[ row 4 ]]
    {
        { type = "blue" }, { type = "blue" }, { type = "blue" }, { type = "blue" }, { type = "blue" }, { type = "blue", power_up = "C" }, { type = "blue" }, { type = "blue" }, { type = "blue" }, { type = "blue" }, { type = "blue" },{ type = "blue" },{ type = "blue" },
    },
    --[[ row 5 ]]
    {
        { type = "green" }, { type = "green" }, { type = "green" }, { type = "green" }, { type = "green" }, { type = "green" }, { type = "green" }, { type = "green", power_up = "L" }, { type = "green" }, { type = "green" }, { type = "green" },{ type = "green" },{ type = "green" },
    },
    --[[ row 6 - additional row for remaining power-ups ]]
    {
        { type = "gray", power_up = "B" }, { type = "gray", power_up = "M" }, { type = "gray", power_up = "P" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray" }, { type = "gray" },
    },
}

return M
