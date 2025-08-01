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

---@class AABB
---@field center_x number
---@field center_y number
---@field half_width number
---@field half_height number

---@param a AABB
---@param b AABB
---@param vel_x number
---@param vel_y number
---@return 'left' | 'right' | 'top' | 'bottom' | nil
local function get_collision_side(a, b, vel_x, vel_y)
    -- Calculate the distance between centers on both axes
    local dx = a.center_x - b.center_x
    local dy = a.center_y - b.center_y

    -- Calculate the maximum distance the boxes can be apart without overlapping
    local combined_half_widths = (a.half_width + b.half_width) / 2
    local combined_half_heights = (a.half_height + b.half_height) / 2

    -- Calculate how much the two boxes are overlapping on each axis
    local overlap_x = combined_half_widths - math.abs(dx)
    local overlap_y = combined_half_heights - math.abs(dy)

    -- If there is no overlap on either axis, there is no collision
    if overlap_x < 0 or overlap_y < 0 then
        return nil
    end

    -- Resolve collision on the axis with the smallest overlap (least penetration)
    if overlap_x < overlap_y then
        -- Horizontal collision: determine side based on relative position
        if dx > 0 then
            return "left" -- a is to the right of b → collision on b's left
        else
            return "right" -- a is to the left of b → collision on b's right
        end
    elseif overlap_y < overlap_x then
        -- Vertical collision: determine side based on relative position
        if dy > 0 then
            return "top" -- a is below b → collision on b's top
        else
            return "bottom" -- a is above b → collision on b's bottom
        end
    else
        -- Equal overlap on both axes: ambiguous — break the tie with velocity
        if math.abs(vel_x) > math.abs(vel_y) then
            if vel_x > 0 then
                return "left"
            else
                return "right"
            end
        else
            if vel_y > 0 then
                return "top"
            else
                return "bottom"
            end
        end
    end
end

return {
    check_rectangle_collision = check_rectangle_collision,
    check_out_of_bond = check_out_of_bond,
    get_collisionSide = get_collision_side,
}
