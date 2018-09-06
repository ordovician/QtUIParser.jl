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

function show(io::IO, orientation::Orientation)
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

function xml(r::Rect)
    parent = ElementNode("rect")

    addchildren!(parent, [
        "x" => string(r.x),
        "y" => string(r.y),
        "width" => string(r.width),
        "height" => string(r.height)])
    parent
end

function xml(sz::Size)
    parent = ElementNode("size")

    addchildren!(parent, [
        "width"  => string(sz.width),
        "height" => string(sz.height)])
    parent
end

function xml(orientation::Orientation)
    s = if orientation == HORIZONTAL
            "Qt::Horizontal"
        elseif orientation == VERTICAL
            "Qt::Vertical"
        end
    ElementNode("enum", s)
end

xml(on::Bool) = ElementNode("bool", string(on))
xml(text::AbstractString) = ElementNode("string", text)
