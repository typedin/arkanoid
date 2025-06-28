---@param obj1 table Object with getGeometry() method
---@param obj2 table Object with getGeometry() method
---@return boolean
local function check_rectangle_collision(obj1, obj2)
    local geom1 = obj1:getGeometry()
    local geom2 = obj2:getGeometry()
    -- Check if rectangles overlap
    -- Rectangle 1 is to the left of Rectangle 2
    if geom1.right < geom2.left then
        return false
    end

    -- Rectangle 1 is to the right of Rectangle 2
    if geom1.left > geom2.right then
        return false
    end

    -- Rectangle 1 is above Rectangle 2
    if geom1.bottom < geom2.top then
        return false
    end

    -- Rectangle 1 is below Rectangle 2
    if geom1.top > geom2.bottom then
        return false
    end

    -- If none of the above conditions are true, rectangles overlap
    return true
end

---@param object table Object with getGeometry() method
---@param area table Area with x, y, width, height properties
---@return boolean
local function check_out_of_bond(object, area)
    local geom = object:getGeometry()

    -- Check if object is outside the area bounds
    -- Object is to the left of the area
    if geom.right < area.x then
        return true
    end

    -- Object is to the right of the area
    if geom.left > area.x + area.width then
        return true
    end

    -- Object is above the area
    if geom.bottom < area.y then
        return true
    end

    -- Object is below the area
    if geom.top > area.y + area.height then
        return true
    end

    -- If none of the above conditions are true, object is within the area
    return false
end

return {
    check_rectangle_collision = check_rectangle_collision,
    check_out_of_bond = check_out_of_bond,
}
