export Layout,
       BoxLayout, GridLayout, GridItem

"A layout which lays out items vertical or horizontal depending on `orientation`"
mutable struct BoxLayout <: Layout
    name::String
    orientation::Orientation
    items::Vector{Union{Layout, Widget, Spacer}}
end

function BoxLayout(name::AbstractString, orientation::Orientation = HORIZONTAL)
    BoxLayout(name, orientation, Union{Layout, Widget, Spacer}[])
end

struct GridItem
    row::Int
    column::Int
    item::Union{Layout, Widget, Spacer}
end

mutable struct GridLayout <: Layout
   name::String
   items::Vector{GridItem}
end

GridLayout(name::AbstractString) = GridLayout(name, GridItem[])

##################### IO #####################

function show(io::IO, item::GridItem, depth::Integer)
    indent = tab^depth
    println(io, indent, "GridItem($(item.row), $(item.column),")
    show(io, item.item, depth + 1)
    print(io, ")")
end

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

function print_layout_properties(io::IO, layout::GridLayout, depth::Integer)
    indent = tab^depth
    properties = Property[property("name", layout.name)]
    show(io, properties, depth + 1)
    if !isempty(layout.items)
        println(io, ",")
        print_items(io, layout.items, depth + 1)
    end
    println(io)
    print(io, indent, ")")
end

function print_items(io::IO, items::Vector{T}, depth::Integer = 0) where T <: Union{Widget, Layout, Spacer, GridItem}
    indent = tab^depth
    println(io, indent, "items = [")
    if !isempty(items)
        for item in items[1:end-1]
            show(io, item, depth + 1)
            println(io, ",")
        end
        show(io, items[end], depth + 1)
    end
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

function xml(layout::GridLayout)
    node = ElementNode("layout", ["class"=>"QGridLayout", "name"=>layout.name])
    for item in layout.items
        item_node =  ElementNode("item", ["row"=>string(item.row), "column" => string(item.column)])
        addchild!(item_node, xml(item.item))
        addchild!(node, item_node)
    end
    node
end
