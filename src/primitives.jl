export Rect, Size, Orientation,
       HORIZONTAL, VERTICAL

"Define the placement and size of a widget. Used for the geometry property"
struct Rect
    x::Int
    y::Int
    width::Int
    height::Int
end

struct Size
    width::Int
    height::Int
end

"Sliders and box layouts may have orientations"
@enum Orientation HORIZONTAL VERTICAL

##################### IO #####################

function show(io::IO, orientation::Orientation, depth::Integer = 0)
    if VERTICAL == orientation
        print(io, "VERTICAL")
    elseif HORIZONTAL == orientation
        print(io, "HORIZONTAL")
    else
        @warn "Orientation '$orientation' not handled by show(). Inserting UNKNOWN as placeholder"
        print(io, "UNKNOWN")
    end
end

##################### XML #####################
