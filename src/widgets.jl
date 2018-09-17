export Widget,
       PushButton, CheckBox, RadioButton, Label, LineEdit,
       SpinBox, GroupBox, TextEdit, ToolButton, ComboBox

function config_widget!(w::Widget, args)
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

function Widget(name::AbstractString, class::Symbol)
    Widget(name, class, Assoc{Symbol, String}(), Assoc{Symbol, Primitive}(), String[], nothing)
end

function Widget(;args...)
    w = Widget("noname",  :QWidget)
    config_widget!(w, args)
end

const labeled_widgets = [:PushButton, :CheckBox, :RadioButton, :Label, :LineEdit]
for T in labeled_widgets
    s = string(T)
    @eval begin
      function $T(name::AbstractString, label::AbstractString)
          w = Widget(name, Symbol($s))
          w.attributes.text = label
          w
      end
    end
end

const name_only_widget = [:SpinBox, :GroupBox, :TextEdit, :ToolButton, :ComboBox]
for T in name_only_widget
    s = string(T)
    @eval begin
      function $T(name::AbstractString)
          Widget(name, Symbol($s))
      end
    end
end


const supported_widgets = union(labeled_widgets, name_only_widget)
for T in supported_widgets
    s = string(T)
    @eval begin
      function $T(;args...)
          w = Widget("noname", Symbol($s))
          config_widget!(w, args)
      end
    end
end

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

function pretty_print(io::IO, w::Widget, depth::Integer)
    show(io, w, depth)
end

function pretty_print(io::IO, obj, depth::Integer)
    if get(io, :indent, true)
        print(io, tab^depth)
    end
    print(io, repr(obj, context = IOContext(io, :compact => true)))
end


function show(io::IO, w::Widget, depth::Integer = 0)
    indent = tab^depth
    traits = Any[:name => w.name]
    
    # In case it starts on an existing line. You don't want indentation before the Widget name
    if get(io, :indent, true)
        print(io, indent)
    end
    io = IOContext(io, :indent => true)
    
    if w.class in supported_widgets
        print(io, string(w.class))
    else
        print(io, "Widget")
        push!(traits, :class => w.class)
    end
    
    if isempty(w.properties) && isempty(w.attributes) && isempty(w.items) && w.layout == nothing
        print(io, "(")
        join(io, repr.(last.(traits)), ", ")
        print(io, ")")
    else
        println(io, "(")

        pretty_print_collection(io, union(traits, 
                                          w.properties, 
                                          w.attributes), 
                                depth + 1)
        pretty_print_items(io, w.items, depth + 1)
        if w.layout != nothing
            println(io, ",")
            print(io, indent, tab, "layout = ")
            show(IOContext(io, :indent => false), w.layout, depth + 1) 
        end
        println(io)
        print(io, indent, ")")
    end
end