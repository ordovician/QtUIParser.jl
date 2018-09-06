export Layout,
       BoxLayout

"A layout which lays out items vertical or horizontal depending on `orientation`"
mutable struct BoxLayout <: Layout
    name::String
    orientation::Orientation
    items::Vector{Union{Layout, Widget, Spacer}}
end

function BoxLayout(name::AbstractString, orientation::Orientation = HORIZONTAL)
    BoxLayout(name, orientation, Union{Layout, Widget, Spacer}[])
end

##################### IO #####################

function print_layout(io::IO, layout::Layout, depth::Integer = 0)
    indent = tab^depth
    println(io, indent, "layout = ")
    show(io, layout, depth + 1)
end

function print_items(io::IO, items::Array{T}, depth::Integer = 0) where T <: Union{Widget, Layout, Spacer}
    indent = tab^depth
    println(io, indent, "items = [")
    for item in items[1:end-1]
        show(io, item, depth + 1)
        println(io, ",")
    end
    show(io, items[end], depth + 1)
    println(io)
    print(io, indent, "]")
end

function show(io::IO, layout::BoxLayout, depth::Integer = 0)
    indent = tab^depth
    println(io, indent, "BoxLayout(")
    properties = Property[property("name", layout.name),
                          property("orientation", layout.orientation)]
    show(io, properties, depth + 1)
    if !isempty(layout.items)
        println(io, ",")
        print_items(io, layout.items, depth + 1)
    end
    println(io)
    println(io, indent, ")")
end

##################### XML #####################

"""
    xml(boxlayout)
Create XML representation for a vertical or horizontal box layout
"""
function xml(layout::BoxLayout)
    class = if layout.orientation == HORIZONTAL
        "QHBoxLayout"
    elseif layout.orientation == VERTICAL
        "QVBoxLayout"
    end
    node = ElementNode("layout", ["class"=>class, "name"=>layout.name])
    for item in layout.items
       addchild!(node, ElementNode("item", [xml(item)]))
    end
    node
end

function boxlayout(name::AbstractString, orientation::Orientation, items...)
    xml(BoxLayout(name, orientation, items))
end

function vboxlayout(name::AbstractString, items...)
    boxlayout(name, VERTICAL, items...)
end

function hboxlayout(name::AbstractString, items...)
    boxlayout(name, HORIZONTAL, items...)
end
