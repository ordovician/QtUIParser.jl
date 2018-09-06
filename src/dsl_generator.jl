# How much indentation to use for each indentation level
const tab = "    "

function show(io::IO, spacer::Spacer, depth::Integer = 0)
    indent = tab^depth
    if isempty(spacer.properties)
        print(io, indent, "Spacer(\"$(spacer.name)\", $(spacer.orientation), $(spacer.size_hint))")
    else
        println(io, indent, "Spacer(")
        properties = Property[property("name", spacer.name),
                              property("orientation", spacer.orientation),
                              property("sizeHint", spacer.size_hint),
                              w.properties...]
        show(io, spacer.properties, depth + 1)
        print(io, indent, ")")
    end
end

function show(io::IO, prop::Property, depth::Integer = 0)
    print(io, tab^depth)
    print(io, prop.name, " = ")
    show(io, propvalue(prop))
end

function show(io::IO, orientation::Orientation)
    if VERTICAL == orientation
        print(io, "VERTICAL")
    elseif HORIZONTAL == orientation
        print(io, "HORIZONTAL")
    else
        @warn "Orientation '$orientation' not handled by show(). Inserting UNKNOWN as placeholder"
        print(io, "UNKNOWN")
    end
end

function show(io::IO, properties::Vector{T}, depth::Integer = 0) where T <: Property
    for prop in properties[1:end-1]
        show(io, prop, depth)
        println(io, ",")
    end
    show(io, properties[end], depth)
end

function show(io::IO, w::Union{PushButton, CheckBox, RadioButton}, depth::Integer = 0)
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

function print_layout(io::IO, layout::Layout, depth::Integer = 0)
    indent = tab^depth
    println(io, indent, "layout = ")
    show(io, layout, depth + 1)
end

function show(io::IO, w::CustomWidget, depth::Integer = 0)
    indent = tab^depth
    print(io, indent, "Widget")

    if isempty(w.properties) && w.layout == nothing
        print(io, "(\"$(w.name)\", \"$(w.class)\")")
    else
        println(io, "(")
        properties = Property[property("name", w.name),
                              property("class", w.class),
                              w.properties...]
        show(io, properties, depth + 1)
        println(io, ",")
        print_layout(io, w.layout, depth + 1)
        print(io, indent, ")")
    end
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

function show(io::IO, layout::BoxLayout, depth::Integer = 0)
    indent = tab^depth
    println(io, indent, "BoxLayout(")
    properties = Property[property("name", layout.name),
                          property("orientation", layout.orientation)]
    show(io, properties, depth + 1)
    if !isempty(layout.items)
        println(io, ",")
        print_items(io, layout.items, depth + 1)
    end
    println(io)
    println(io, indent, ")")
end

function show(io::IO, ui::Ui)
    depth = 0
    println(io, "Ui(")
    properties = Property[property("class", ui.class),
                          property("version", ui.version)]
    show(io, properties, depth + 1)
    println(io, ",")
    println(io, tab, "root = ")
    show(io, ui.root_widget, depth + 1)
    println(io)
    print(io, ")")
end
