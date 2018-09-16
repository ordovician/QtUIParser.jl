export Widget,
       PushButton, CheckBox, RadioButton, Label, LineEdit

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
  
      function $T(;args...)
          w = Widget("noname", Symbol($s))
          config_widget!(w, args)
      end
    end
end

const supported_widgets = union(labeled_widgets)

function pretty_print_collection(io::IO, a, depth::Integer = 0)
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
        pretty_print(io, v, depth)
    end 
end

function pretty_print_array(io::IO, xs::Vector, depth::Integer = 0)
    indent = tab^depth
    
    isfirst = true
    for x in xs
        if isfirst
            isfirst = false
        else
            println(io, ",")
        end
        print(io, indent, tab, repr(x))
    end    
end


function pretty_print(io::IO, obj, depth::Integer = 0)
    print(io, repr(obj))
end

function show(io::IO, w::Widget, depth::Integer = 0)
    indent = tab^depth
    traits = Any[:name => w.name]
    if w.class in supported_widgets
        print(io, indent, string(w.class))
    else
        print(io, indent, "Widget")
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
        if !isempty(w.items)
           println(io, ",")
           println(io, indent, tab, "items = [")
           pretty_print_array(io, w.items, depth + 1)
           println(io)
           print(io, indent, tab, "]") 
        end
        println(io)
        print(io, ")")
    end
end