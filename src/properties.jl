export Property,
       TextProperty, BoolProperty, GeometryProperty, OrientationProperty

struct TextProperty <: Property
   name::String
   value::String
end

property(text::AbstractString) = TextProperty("text", text)

struct OrientationProperty <: Property
    name::String
    value::Orientation
end

property(orientation::Orientation) = OrientationProperty("orientation", orientation)

struct GeometryProperty <: Property
    name::String
    value::Rect
end

struct SizeProperty <: Property
    name::String
    value::Size
end

property(rect::Rect) = GeometryProperty("geometry", rect)

struct BoolProperty <: Property
    name::String
    value::Bool
end

"Get the value of the property, regardless of whether it is boolean, text or orientation"
propvalue(p::Property) = p.value

"""
Creates a property named `name`. The concrete `Property` type used will
depend on the type of value provided.

    property(name, rect)
Create a property holding a rectangle. Used to represent the geometry of a widget.
"""
property(name::AbstractString, r::Rect) = GeometryProperty(name, r)

property(name::AbstractString, sz::Size) = SizeProperty(name, sz)

"""
    property(name, text)
Text property which can be used for e.g. a window title or label of a widget.
"""
property(name::AbstractString, text::AbstractString) = TextProperty(name, text)

"""
    property(name, orientation)
Orientation of a widget. E.g. is the slider horizontal or vertical.
"""
property(name::AbstractString, orientation::Orientation) = OrientationProperty(name, orientation)

"""
    property(name, on)
Boolean property. Useful for the state of check boxes or radio buttons.
"""
property(name::AbstractString, on::Bool) = BoolProperty(name, on)

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
    error("Must implement xml(", typeof(p), ")")
end

"""
    xml(property)
XML representation of a subclass of `Property`. Used to describe aspects
of a widget.
"""
function xml(p::GeometryProperty)
    pnode = ElementNode("property", ["name"=>p.name])
    rnode = ElementNode("rect")
    addchild!(pnode, rnode)

    r = p.value
    addchildren!(rnode, [
        "x" => string(r.x),
        "y" => string(r.y),
        "width" => string(r.width),
        "height" => string(r.height)])
    pnode
end

function xml(p::SizeProperty)
    pnode  = ElementNode("property", ["name"=>p.name, "stdset"=>"0"])
    sznode = ElementNode("size")
    addchild!(pnode, sznode)

    sz = p.value
    addchildren!(sznode, [
        "width"  => string(sz.width),
        "height" => string(sz.height)])
    pnode
end

function xml(p::TextProperty)
    node = ElementNode("property", ["name"=>p.name])
    addchild!(node, ElementNode("string", p.value))
    node
end

function xml(p::OrientationProperty)
    node = ElementNode("property", ["name"=>p.name])
    s = if p.value == HORIZONTAL
            "Qt::Horizontal"
        elseif p.value == VERTICAL
            "Qt::Vertical"
        end
    addchild!(node, ElementNode("enum", s))
    node
end

function xml(p::BoolProperty)
    node = ElementNode("property", ["name"=>p.name])
    addchild!(node, ElementNode("bool", string(p.value)))
    node
end
