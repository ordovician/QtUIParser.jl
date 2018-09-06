export Property   

struct Property
    name::String
    value::Union{String, Orientation, Rect, Size, Bool}
end

property(text::AbstractString)     = Property("text", text)
property(orientation::Orientation) = Property("orientation", orientation)
property(rect::Rect)               = Property("geometry", rect)

function property(name::AbstractString, value::Union{String, Orientation, Rect, Size, Bool})
    Property(name, value)
end

"Get the value of the property, regardless of whether it is boolean, text or orientation"
propvalue(p::Property) = p.value

##################### IO #####################

function show(io::IO, prop::Property, depth::Integer = 0)
    print(io, tab^depth)
    print(io, prop.name, " = ")
    show(io, propvalue(prop))
end

function show(io::IO, properties::Vector{T}, depth::Integer = 0) where T <: Property
    for prop in properties[1:end-1]
        show(io, prop, depth)
        println(io, ",")
    end
    show(io, properties[end], depth)
end

##################### XML #####################
function xml(p::Property)
    parent = ElementNode("property", ["name"=>p.name])
    child  = xml(p.value)
    addchild!(parent, child)
    parent
end

"""
    xml(property)
XML representation of a subclass of `Property`. Used to describe aspects
of a widget.
"""
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
