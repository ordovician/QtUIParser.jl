export Layout,
       BoxLayout, VBoxLayout, HBoxLayout,
       GridLayout, GridItem


function BoxLayout(name::AbstractString, orientation::Orientation = HORIZONTAL, items::Array{Item} = Item[])
    a = Assoc{Symbol, Primitive}()
    a[:orientation] = orientation
    BoxLayout(name, a, items)
end

VBoxLayout(name) = BoxLayout(name, VERTICAL)
HBoxLayout(name) = BoxLayout(name, HORIZONTAL)


function GridLayout(name::AbstractString, items = GridItem[])
    GridLayout(name, Assoc{Symbol, Primitive}(), items)
end

function config_layout!(l::Layout, args)
    for (k, v) in args
        if k == :items
            l.items = v
        elseif k in fieldnames(typeof(l))
            setfield!(l, k, v)
        else
            l.properties[k] = v
        end
    end
    l
end

for T in [:BoxLayout, :VBoxLayout, :HBoxLayout, :GridLayout]
    @eval begin
      function $T(;args...)
          layout = $T("noname")
          config_layout!(layout, args)
      end
    end
end

##################### IO #####################

function show(io::IO, item::GridItem, depth::Integer = 0)
    indent = tab^depth
    print(io, indent, "GridItem($(item.row), $(item.column),")
    if item.rowspan == 1 && item.colspan == 1
        println(io)
    else
        println(io, " ", item.rowspan, ", ", item.colspan, ",")
    end
    show(io, item.item, depth + 1)
    print(io, ")")
end

pretty_print(io::IO, item::GridItem, depth::Integer) = show(io, item, depth)


function show(io::IO, layout::Layout, depth::Integer = 0)
    indent = tab^depth

    if get(io, :indent, true)
        print(io, indent)
    end

    io = IOContext(io, :indent => true)

    properties = copy(layout.properties)
    if isa(layout, BoxLayout) && haskey(properties, :orientation)
        if properties.orientation == VERTICAL
            println(io, "VBoxLayout(")
        elseif properties.orientation == HORIZONTAL
            println(io, "HBoxLayout(")
        else
            error("Unknown BoxLayout orientation")
        end
        delete!(properties, :orientation)
    else
        println(io, "$(typeof(layout))(")
    end

    traits = Any[:name => layout.name]
    pretty_print_collection(io, union(traits, properties),
                            depth + 1)
    pretty_print_items(io, layout.items, depth + 1)
    println(io)
    print(io, indent, ")")
end

##################### XML #####################
"""
    xml(boxlayout)
Create XML representation for a vertical or horizontal box layout
"""
function xml(layout::BoxLayout)
    orientation = layout.properties[:orientation]
    class = if orientation == HORIZONTAL
        "QHBoxLayout"
    elseif     orientation == VERTICAL
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
        props = ["row"=>string(item.row), "column" => string(item.column)]
        if item.rowspan > 1
            push!(props, "rowspan" => string(item.rowspan))
        end
        if item.colspan > 1
            push!(props, "colspan" => string(item.colspan))
        end
        item_node =  ElementNode("item", props)
        addchild!(item_node, xml(item.item))
        addchild!(node, item_node)
    end
    node
end
