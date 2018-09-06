export Layout,
       BoxLayout, GridLayout

"A layout which lays out items vertical or horizontal depending on `orientation`"
mutable struct BoxLayout <: Layout
    name::String
    orientation::Orientation
    items::Vector{Union{Layout, Widget, Spacer}}
end

function BoxLayout(name::AbstractString, orientation::Orientation = HORIZONTAL)
    BoxLayout(name, orientation, Union{Layout, Widget, Spacer}[])
end

mutable struct GridLayout <: Layout
   name::String
   items::Vector{Union{Layout, Widget, Spacer}} 
end

GridLayout(name::AbstractString) = GridLayout(name, Union{Layout, Widget, Spacer}[])

##################### IO #####################

function print_layout_properties(io::IO, layout::Layout, depth::Integer)
    indent = tab^depth
    properties = Property[property("name", layout.name)]
    if :orientation in fieldnames(typeof(layout))
        push!(properties, property("orientation", layout.orientation))
    end
    show(io, properties, depth + 1)
    if !isempty(layout.items)
        println(io, ",")
        print_items(io, layout.items, depth + 1)
    end
    println(io)
    print(io, indent, ")")
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

function show(io::IO, layout::Layout, depth::Integer = 0)
    indent = tab^depth
    println(io, indent, "$(typeof(layout))(")
    print_layout_properties(io, layout, depth)
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
