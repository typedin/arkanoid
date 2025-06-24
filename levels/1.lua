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
        { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" }, { kind = "gray" },
    },
    --[[ row 2 ]]
    {
        { kind = "red" }, { kind = "red" }, { kind = "red" }, { kind = "red" }, { kind = "red" }, { kind = "red" }, { kind = "red" }, { kind = "red" }, { kind = "red" }, { kind = "red" },  { kind = "red" },{ kind = "red" },{ kind = "red" },
	},
    --[[ row 3 ]]
    {
        { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" }, { kind = "yellow" },
	},
    --[[ row 4 ]]
    {
        { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" }, { kind = "blue" },{ kind = "blue" },{ kind = "blue" },
    },
    --[[ row 5 ]]
    {
        { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green" }, { kind = "green" },{ kind = "green" },{ kind = "green" },
    },
}

return M
