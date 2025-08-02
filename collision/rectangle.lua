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

---@param disc Disc
---@param rectangle Rectangle
---@return boolean
local function check_disc_aabb_collision(disc, rectangle)
    local closest_x = math.max(rectangle.x, math.min(disc:getGeometry().center_x, rectangle.x + rectangle.width))
    local closest_y = math.max(rectangle.y, math.min(disc:getGeometry().center_y, rectangle.y + rectangle.height))

    local distance_x = disc:getGeometry().center_x - closest_x
    local distance_y = disc:getGeometry().center_y - closest_y

    return (distance_x * distance_x + distance_y * distance_y) <= disc.radius * disc.radius
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

---@param a Rectangle | Disc
---@param b Rectangle | Disc
---@param vel_x number
---@param vel_y number
---@return 'left' | 'right' | 'top' | 'bottom' | nil
local function get_collision_side(a, b, vel_x, vel_y)
    assert(type(a) == "table", "Rectangle:get_collision_side requires a as a table")
    assert(type(b) == "table", "Rectangle:get_collision_side requires b as a table")

    assert(type(vel_x) == "number", "Rectangle:get_collision_side requires vel_x as a number")
    assert(type(vel_y) == "number", "Rectangle:get_collision_side requires vel_y as a number")
    -- Calculate the distance between centers on both axes
    local dx = a:getGeometry().center_x - b:getGeometry().center_x
    local dy = a:getGeometry().center_y - b:getGeometry().center_y

    -- Calculate the maximum distance the boxes can be apart without overlapping
    local combined_half_widths = (a:getGeometry().half_width + b:getGeometry().half_width) / 2
    local combined_half_heights = (a:getGeometry().half_height + b:getGeometry().half_height) / 2

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
    check_out_of_bond = check_out_of_bond,
    check_disc_rectangle_collision = check_disc_aabb_collision,
    check_rectangle_collision = check_rectangle_collision,
    get_collision_side = get_collision_side,
}
