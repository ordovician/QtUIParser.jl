export spacer

mutable struct Spacer
    name::String
    orientation::Orientation
    size_hint::Size
    properties::Vector{Property}
end

"""
     Spacer(name, orientation, size_hint)
Creates a strech or space inside a layout. It can be used to expand empty
space, avoiding that other GUI components are made bigger.
"""
function Spacer(name, orientation, size_hint)
    Spacer(name, orientation, size_hint, Property[])
end

##################### IO #####################

function show(io::IO, spacer::Spacer, depth::Integer = 0)
    indent = tab^depth
    if isempty(spacer.properties)
        print(io, indent, "Spacer(\"$(spacer.name)\", $(spacer.orientation), $(spacer.size_hint))")
    else
        println(io, indent, "Spacer(")
        properties = Property[property("name", spacer.name),
                              property("orientation", spacer.orientation),
                              property("sizeHint", spacer.size_hint),
                              w.properties...]
        show(io, spacer.properties, depth + 1)
        print(io, indent, ")")
    end
end

##################### XML #####################

function add_property_nodes!(node::Node, w::Union{Spacer, Widget})
    for p in w.properties
        addchild!(node, xml(p))
    end
end

function xml(spacer::Spacer)
    node =  ElementNode("spacer", ["name"=>spacer.name])
    addchild!(node, xml(property(spacer.orientation)))
    addchild!(node, xml(property("sizeHint", spacer.size_hint)))
    add_property_nodes!(node, spacer)
    node
end
