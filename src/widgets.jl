export QWidget,
       QPushButton, QCheckBox, QRadioButton, QLabel, QLineEdit,
       QSpinBox, QGroupBox, QTextEdit, QToolButton, QComboBox,
       QSlider

function config_widget!(w::QWidget, args)
    for (k, v) in args
        if k in fieldnames(typeof(w))
            setfield!(w, k, v)
        elseif k in [:title]
            w.attributes[k] = v
        else
            w.properties[k] = v
        end
    end
    w
end

function QWidget(name::AbstractString, class::Symbol)
    QWidget(name, class, Assoc{Symbol, String}(), Assoc{Symbol, Primitive}(), String[], nothing, QWidget[])
end

function QWidget(;args...)
    w = QWidget("noname",  :QWidget)
    config_widget!(w, args)
end

const labeled_widgets = [:QPushButton, :QCheckBox, :QRadioButton, :QLabel, :QLineEdit]
for T in labeled_widgets
    s = string(T)
    @eval begin
      function $T(name::AbstractString, label::AbstractString)
          w = QWidget(name, Symbol($s))
          w.properties.text = label
          w
      end
    end
end

const name_only_widget = [:QSpinBox, :QGroupBox, :QTextEdit, :QToolButton, :QComboBox]
for T in name_only_widget
    s = string(T)
    @eval begin
      function $T(name::AbstractString)
          QWidget(name, Symbol($s))
      end
    end
end

function QSlider(name::AbstractString, orientation::Orientation)
    w = QWidget(name, :QSlider)
    w.properties[:orientation] = orientation
    w
end

const supported_widgets = union(labeled_widgets, name_only_widget, [:QSlider])
for T in supported_widgets
    s = string(T)
    @eval begin
      function $T(;args...)
          w = QWidget("noname", Symbol($s))
          config_widget!(w, args)
      end
    end
end

##################### IO #####################

function pretty_print_collection(io::IO, a, depth::Integer)
    indent = tab^depth
    ks = string.(first.(collect(a)))
    max_width = maximum(length.(ks))

    isfirst = true
    for (k, v) in a
        if isfirst
            isfirst = false
        else
            println(io, ",")
        end
        sk = rpad(string(k), max_width)
        print(io, indent, "$sk = ")
        pretty_print(IOContext(io, :indent => false), v, depth + 1)
    end
end

function pretty_print_array(io::IO, xs::Vector, depth::Integer)
    indent = tab^depth

    isfirst = true
    for x in xs
        if isfirst
            isfirst = false
        else
            println(io, ",")
        end
        pretty_print(io, x, depth + 1)
    end
end

"For printing items for a widget. Not for printing items separately"
function pretty_print_items(io::IO, items, depth::Integer)
    indent = tab^depth
    if !isempty(items)
       println(io, ",")
       println(io, indent, "items = [")
       pretty_print_array(io, items, depth)
       println(io)
       print(io, indent, "]")
    end
end

# TODO: factor out similar code to pretty_print_items
function pretty_print_widgets(io::IO, items, depth::Integer)
    indent = tab^depth
    if !isempty(items)
       println(io, ",")
       println(io, indent, "children = [")
       pretty_print_array(io, items, depth)
       println(io)
       print(io, indent, "]")
    end
end

"For printing layout info for a widget. Not for printing layout object separately"
function pretty_print_layout(io::IO, layout::Union{Layout, Nothing}, depth::Integer)
    indent = tab^depth
    if layout != nothing
        println(io, ",")
        print(io, indent, "layout = ")
        show(IOContext(io, :indent => false), layout, depth)
    end
end

function pretty_print(io::IO, item::Item, depth::Integer)
    show(io, item, depth)
end

function pretty_print(io::IO, obj, depth::Integer)
    if get(io, :indent, true)
        print(io, tab^depth)
    end
    print(io, repr(obj, context = IOContext(io, :compact => true)))
end

"Returns properties not added to traits for this widget type"
function filter_properties(properties::Assoc{K, V}, class::Symbol, traits) where {K, V}
    result = copy(properties)
    if class in supported_widgets
        if class in labeled_widgets
            push!(traits, :text => get(result, :text, ""))
            delete!(result, :text)
        elseif class == :QSlider
            push!(traits, :orientation => get(result, :orientation, HORIZONTAL))
            delete!(result, :orientation)
        end
    else
        push!(traits, :class => class)
    end
    result
end



function show(io::IO, w::QWidget, depth::Integer = 0)
    indent = tab^depth
    traits = Any[:name => w.name]

    # In case it starts on an existing line. You don't want indentation before the QWidget name
    if get(io, :indent, true)
        print(io, indent)
    end
    io = IOContext(io, :indent => true)

    if w.class in supported_widgets
        print(io, string(w.class))
    else
        print(io, "QWidget")
    end

    properties = filter_properties(w.properties, w.class, traits)

    if all(isempty, [properties, w.attributes, w.items, w.children]) && w.layout == nothing
        print(io, "(")
        join( io, repr.(last.(traits), context = IOContext(io, :compact => true)), ", ")
        print(io, ")")
    else
        println(io, "(")

        pretty_print_collection(io, union(traits,
                                          properties,
                                          w.attributes),
                                depth + 1)
        pretty_print_items( io, w.items,    depth + 1)
        pretty_print_layout(io, w.layout,   depth + 1)
        pretty_print_widgets(io, w.children, depth + 1)
        println(io)
        print(io, indent, ")")
    end
end

##################### XML #####################

function xml(w::QWidget)
    node = ElementNode("widget", ["class"=>string(w.class), "name"=>w.name])
    node.children = xml(w.properties)
    if w.layout != nothing
        addchild!(node, xml(w.layout))
    end
    item_nodes = map(w.items) do item
        ElementNode("item", [xml(:text => item)])
    end
    append!(node.children, item_nodes)
    node
end
