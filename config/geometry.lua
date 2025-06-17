local M = {}

function M.get_geometry(obj)
    return {
        x = obj.x,
        y = obj.y,
        width = obj.width,
        height = obj.height,
        left = obj.x,
        right = obj.x + obj.width,
        top = obj.y,
        bottom = obj.y + obj.height,
    }
end

return M
