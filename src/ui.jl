export Ui

"""
All `.ui` files need to be made with a `Ui` object at the top.
`root` is the root of the widget hierarchy, defining the GUI.
`connections` contains the connections between widgets found in this
hierarchy.
"""
mutable struct Ui
    class::String
    root::Widget
    resources::Vector{Resource}
    connections::Vector{Connection}
    version::String
end

function Ui(class::AbstractString)
    Ui(class, CustomWidget(class), Resource[], Connection[], "4.0")
end

function Ui(root::Widget)
    Ui(root.name, root, Resource[], Connection[], "4.0")
end

##################### IO #####################

function show(io::IO, ui::Ui)
    depth = 0
    println(io, "Ui(")
    properties = Property[property("class", ui.class),
                          property("version", ui.version)]
    show(io, properties, depth + 1)
    println(io, ",")
    print(io, tab, "root = Widget")
    print_widget_properties(io, ui.root, depth + 1)
    println(io)
    print(io, ")")
end

##################### XML #####################
"""
    xml(ui)
Create XML representation of the top-level object of a Qt `.ui` file.
If you want to write a `.ui` this the XML you need.
"""
function xml(ui::Ui)
    node = ElementNode("ui", ["version"=>ui.version])

    node.children =  Node[ElementNode("class", ui.class),
                          xml(ui.root),
                          xml(ui.resources),
                          xml(ui.connections)]
    node
end
