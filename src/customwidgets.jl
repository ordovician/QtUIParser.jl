export CustomWidget

"""
Used to store info about custom widgets. Widgets imported through header files.
"""
mutable struct CustomWidget
    class::Symbol
    super::Symbol
    header_path::String
end

function show(io::IO, items::Vector{CustomWidget}, depth::Integer = 0)
    indent = tab^depth
    if !isempty(items)
       println(io, ",")
       println(io, indent, "customwidgets = [")
       pretty_print_array(io, items, depth)
       println(io)
       print(io, indent, "]")
    end
end

##################### XML #####################
function xml(widgets::Vector{CustomWidget})
    node = ElementNode("customwidgets")
    for w in widgets
        addchild!(node, xml(w))
    end
    node
end

function xml(w::CustomWidget)
    node = ElementNode("customwidget")

    node.children =  Node[ElementNode("class", string(w.class)),
                          ElementNode("extends", string(w.super)),
                          ElementNode("header", w.header_path)]
    node
end
