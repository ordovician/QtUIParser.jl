export Ui

"""
All `.ui` files need to be made with a `Ui` object at the top.
`root` is the root of the widget hierarchy, defining the GUI.
`connections` contains the connections between widgets found in this
hierarchy.
"""
mutable struct Ui
    class::String
    root::QWidget
    resources::Vector{Resource}
    connections::Vector{Connection}
    customwidgets::Vector{CustomWidget}
    version::String
end

function Ui(class::AbstractString)
    Ui(class, QWidget(class), Resource[], Connection[], CustomWidget[]. "4.0")
end

function Ui(root::QWidget)
    Ui(root.name, root, Resource[], Connection[], CustomWidget[],  "4.0")
end

function Ui(;class = "Form", version =  "4.0", root = QWidget(class), customwidgets = CustomWidget[])
    Ui(class, root, Resource[], Connection[], customwidgets, version)
end


##################### IO #####################

function show(io::IO, ui::Ui)
    depth = 0
    println(io, "Ui(")

    traits = Any[:class => ui.class, :version => ui.version]
    pretty_print_collection(io, traits, depth + 1)

    println(io, ",")
    print(io, tab, "root = ")
    show(IOContext(io, :indent => false), ui.root, depth + 1)
    show(io, ui.customwidgets, depth + 1)
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
                          xml(ui.customwidgets),
                          xml(ui.resources),
                          xml(ui.connections)]
    node
end
