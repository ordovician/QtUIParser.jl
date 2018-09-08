import Base: setindex!, getindex

export  Widget, CustomWidget,
        PushButton, CheckBox, RadioButton, ToolButton,
        Slider, SpinBox, ComboBox, GroupBox,
        LineEdit, TextEdit, Label

for T in [:PushButton, :CheckBox, :RadioButton, :Label, :LineEdit]
  @eval begin
    mutable struct $T <: Widget
        name::String
        text::String
        properties::Vector{Property}
    end
    $T(name::AbstractString, text::AbstractString = "") = $T(name, text, Property[])
  end
end


for T in [:SpinBox, :GroupBox, :TextEdit, :ToolButton]
    @eval begin
        mutable struct $T <: Widget
            name::String
            properties::Vector{Property}    
        end
        $T(name::AbstractString) = $T(name, Property[])
    end
end

"Allows you to move a slider  between a min and max value"
mutable struct Slider <: Widget
   name::String
   orientation::Orientation
   properties::Vector{Property}
end

function Slider(name::AbstractString, orientation::Orientation = HORIZONTAL)
    Slider(name, orientation, Property[])
end

"User can chose between several choices define by `items`"
mutable struct ComboBox <: Widget
    name::String
    properties::Vector{Property}
    items::Vector{String}
end

function ComboBox(name::AbstractString, items::Vector{T}) where T <: AbstractString
    ComboBox(name, Property[], items)
end

function ComboBox(name::AbstractString)
    ComboBox(name, Property[], String[])
end

"Typically used for custom top level widgets"
mutable struct CustomWidget <: Widget
   name::String
   class::String
   properties::Vector{Property}
   layout::Union{Layout, Nothing}
end

function CustomWidget(name::AbstractString = "Form", class::AbstractString = "QWidget")
    CustomWidget(name, class, Property[], nothing)
end

function Widget(name::AbstractString, class::AbstractString)
    CustomWidget(name, class)
end

######################  Mapping Qt Names to Types ###########################
                                
const orientation_dict =   Assoc(HORIZONTAL => "Qt::Horizontal",
                                 VERTICAL   => "Qt::Vertical" )
                                   
const widget_dict  =     Assoc(PushButton   => "QPushButton",
                               ComboBox     => "QComboBox",
                               CheckBox     => "QCheckBox",
                               RadioButton  => "QRadioButton",
                               Slider       => "QSlider",
                               SpinBox      => "QSpinBox",
                               Label        => "QLabel",
                               LineEdit     => "QLineEdit",
                               TextEdit     => "QTextEdit",
                               GroupBox     => "QGroupBox",
                               ToolButton   => "QToolButton",
                               CustomWidget => "QWidget")

########################## Index Accessors #################################

function getindex(w::Widget, key::AbstractString)
    # Check if one of the type field has the key
    sym_key = Symbol(key)
    if sym_key in fieldnames(typeof(w))
        return getfield(w, sym_key)
    end

    # if not lets go through our properties
    for p in w.properties
        if p.name == key
            return p.value
        end
    end
    error("No property with key $key exist")
end

function setindex!(w::Widget, value, key::AbstractString)
    i = findfirst(w->w.name == key, w.properties)
    if i == nothing
        sym_key = Symbol(key)
        fields = fieldnames(typeof(w))
        if sym_key in fields && isa(value, fieldtype(typeof(w), sym_key))
            setfield!(w, sym_key, value)
        else
            push!(w.properties, property(key, value))
        end
    else
        w.properties[i] = property(key, value)
    end
end

##################### IO ##########################################

function show(io::IO, w::Union{PushButton, CheckBox, RadioButton, Label, LineEdit}, depth::Integer = 0)
    indent = tab^depth
    print(io, indent, string(typeof(w)))

    if isempty(w.properties)
        print(io, "(\"$(w.name)\", \"$(w.text)\")")
    else
        println(io, "(")
        properties = Property[property("name", w.name),
                              property("text", w.text),
                              w.properties...]
        show(io, properties, depth + 1)
        println(io)
        print(io, indent, ")")
    end
end

function show(io::IO, w::Slider, depth::Integer = 0)
    indent = tab^depth
    print(io, indent, string(typeof(w)))

    if isempty(w.properties)
        print(io, "(\"$(w.name)\", $(w.orientation))")
    else
        println(io, "(")
        properties = Property[property("name", w.name),
                              property("orientation", w.orientation),
                              w.properties...]
        show(io, properties, depth + 1)
        println(io)
        print(io, indent, ")")
    end
end

function show(io::IO, w::Union{SpinBox, GroupBox, TextEdit, ToolButton}, depth::Integer = 0)
    indent = tab^depth
    print(io, indent, string(typeof(w)))

    if isempty(w.properties)
        print(io, "(\"$(w.name)\")")
    else
        println(io, "(")
        properties = Property[property("name", w.name),
                              w.properties...]
        show(io, properties, depth + 1)
        println(io)
        print(io, indent, ")")
    end
end

function show(io::IO, w::ComboBox, depth::Integer = 0)
    indent = tab^depth
    print(io, indent, string(typeof(w)))

    if isempty(w.properties)
        print(io, "(\"$(w.name)\", [")
        join(io, string.("\"", w.items, "\""), ", ")
        print(io, "])")
    else
        println(io, "(")
        print(io, indent, tab, "name = \"$(w.name)\"")
        if !isempty(w.properties)
           println(io, ",")
           join(io, string.(indent, tab, w.properties), ",\n") 
        end
        
        if !isempty(w.items)
            println(io, ",")
            println(io, indent, tab, "items = [")
            items = string.("\"", w.items, "\"")
            join(io, string.(indent, tab^2, items), ",\n")
            println(io)
            print(io, indent, tab, "]")
        end
        println(io)
        print(io, indent, ")")
    end
end

function print_widget_properties(io::IO, w::CustomWidget, depth::Integer)
    indent = tab^depth
    println(io, "(")
    properties = Property[property("name", w.name),
                          property("class", w.class),
                          w.properties...]
    show(io, properties, depth + 1)
    println(io, ",")
    if w.layout != nothing
        println(io, indent, tab, "layout = $(typeof(w.layout))(")
        print_layout_properties(io, w.layout, depth + 1)
    end
    println(io)
    print(io, indent, ")")
end

function show(io::IO, w::CustomWidget, depth::Integer = 0)
    indent = tab^depth
    print(io, indent, "Widget")

    if isempty(w.properties) && w.layout == nothing
        print(io, "(\"$(w.name)\", \"$(w.class)\")")
    else
        print_widget_properties(io, w, depth)
    end
end

##################### XML #########################################
function class_name(w::Widget)
    widget_dict[typeof(w)]
end

"""
    xml(widget)
Turn a widget such as a combobox, slider or checkbox into a tree of XML nodes.
"""
function xml(w::ComboBox)
    node = widget(class_name(w), w.name)
    add_property_nodes!(node, w)
    for item in w.items
       addchild!(node, ElementNode("item", [xml(property(item))]))
    end
    node
end

function xml(w::Union{SpinBox, GroupBox, TextEdit, ToolButton})
    node = widget(class_name(w), w.name)
    add_property_nodes!(node, w)
    node
end

function xml(w::Slider)
    node = widget(class_name(w), w.name)
    addchild!(node, xml(property(w.orientation)))
    add_property_nodes!(node, w)
    node
end

function xml(w::Union{PushButton, CheckBox, RadioButton, Label, LineEdit})
    node = widget(class_name(w), w.name)
    addchild!(node, xml(property(w.text)))
    add_property_nodes!(node, w)
    node
end

function xml(w::CustomWidget)
    node = widget(w.class, w.name)
    add_property_nodes!(node, w)
    if w.layout != nothing
        addchild!(node, xml(w.layout))
    end
    node
end

function xml(w::Widget)
    error("Must implement xml(", typeof(w), ")")
end

function widget(class::AbstractString, name::AbstractString)
    ElementNode("widget", ["class"=>class, "name"=>name])
end
