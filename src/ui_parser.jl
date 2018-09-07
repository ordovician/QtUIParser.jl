using PLists

export read_ui, read_ui_string,
       findproperty, findwidget

"Convert generic widget to a more specialized on based on properties"
function specialize_widget(w::CustomWidget)
    W = get(cname_to_type_dict, w.class, CustomWidget)
    if W != CustomWidget
        fields = string.(fieldnames(W))
        obj = W(w.name)
        for prop in w.properties
            if prop.name in fields
                setfield!(obj, Symbol(prop.name), propvalue(prop))
            else
                push!(obj.properties, prop)
            end
        end
        obj
    else
        w
    end
end

"Looks for a child node of `n` which is a property with name `name`."
findproperty(n::Node, name::AbstractString) = locatefirst(["property"], "name", name, n)

"""
    findwidget(node, name) -> Node
Recursively search from XML DOM node `node` for a widget named `name`.
# Example

"""
function findwidget(node::Node, name::AbstractString)
    if nodename(node) == "widget" && haskey(node, "name") && node["name"] == name
       return node
    else
        for n in nodes(node)
           m = findwidget(n, name)
           if m != nothing
               return m
           end
        end
    end
    nothing
end

function findwidget(doc::Document, name::AbstractString)
    if !hasroot(doc) return nothing end
    findwidget(root(doc), name)
end

"Convert an Qt enum string such as `Qt::Horizontal` to a Julia enum value"
function parse_enum(s::AbstractString)
    ename_to_enum_dict[s]
end

function parse_rect(n::ElementNode)
    value(key) = Meta.parse(nodecontent(locatefirst(key, n)))
    x       = value("x")
    y       = value("y")
    width   = value("width")
    height  = value("height")
    Rect(x, y, width, height)
end

function parse_size(n::ElementNode)
    value(key) = Meta.parse(nodecontent(locatefirst(key, n)))
    width   = value("width")
    height  = value("height")
    Size(width, height)
end

function parse_property_data(n::ElementNode)
    tag = nodename(n)
    if     "string" == tag
        nodecontent(n)
    elseif "enum" == tag
        parse_enum(nodecontent(n))
    elseif "bool" == tag
        parse(nodecontent(n))
    elseif "rect" == tag
        parse_rect(n)
    elseif "size" == tag
        parse_size(n)
    else
        @error "Unknown property type '$tag' encountered"
    end
end


function parse_property(n::ElementNode)
    name  = n["name"]
    children = elements(n)
    if isempty(children)
        error("property node is missing data")
    end
    data_node = first(children)
    property(name, parse_property_data(data_node))
end

function parse_func_signature(s::AbstractString, T::DataType)
    m = match(r"\s*(\w+)\(([\w,\s]*)\)", s)
    if m == nothing
       @error "Was not able to parse signal or slot method '$s'"
    else
       T(m[1], split(m[2]))
    end
end

function parse_connection(node::ElementNode)
    value(key) = nodecontent(locatefirst(key, n))

    sender     = value("sender")
    receiver   = value("receiver")
    signal_str = value("signal")
    slot_str   = value("slot")

    signal = parse_func_signature(signal_str, Signal)
    slot   = parse_func_signature(signal_str, Slot)

    Connection(sender, signal, receiver, slot)
end

function parse_connections(node::ElementNode)
    connections = elements(node)
    [parse_connection(conn) for conn in connections]
end

function parse_item(tag, child)
    if     "widget" == tag
        parse_widget(child)
    elseif "layout" == tag
        parse_layout(child)
    elseif "spacer" == tag
        parse_spacer(child)
    else
        @error "Don't know how to parse items of type '$tag'"
        nothing
    end
end

function parse_layout(node::ElementNode)
    class = node["class"]
    name  = node["name"]

    items = Union{Layout, Widget, Spacer}[]
    griditems = GridItem[]

    item_nodes = elements(node)
    for item_node in item_nodes
        children = elements(item_node)
        child = first(children)
        tag  = nodename(child)
        item = parse_item(tag, child)
        if item == nothing
            continue
        end

        if "QGridLayout" == class
            row = Meta.parse(item_node["row"])
            col = Meta.parse(item_node["column"])
            push!(griditems, GridItem(row, col, item))
        else
            push!(items, item)
        end
    end

    if     "QVBoxLayout" == class
        BoxLayout(name, VERTICAL, items)
    elseif "QHBoxLayout" == class
        BoxLayout(name, HORIZONTAL, items)
    elseif "QGridLayout" == class
        GridLayout(name, items)
    else
        @error "Missing code to handle Layout of type '$class'"
    end
end

# TODO: Implement when we know more about the structure of resources XML
function parse_resources(node::ElementNode)
    Resource[]
end

function parse_widget(node::ElementNode)
    cname = node["class"] # class name
    name  = node["name"]

    children = elements(node)

    properties = Property[]
    layout = nothing
    for child in children
        tag = nodename(child)
        if     tag == "property"
            push!(properties, parse_property(child))
        elseif tag == "layout"
            layout = parse_layout(child)
        end
    end

    specialize_widget(CustomWidget(name, cname, properties, layout))
end

function parse_spacer(node::ElementNode)
    name  = node["name"]
    children = elements(node)

    properties = Property[]
    orientation = HORIZONTAL
    size_hint = Size(0, 0)
    for child in children
        tag = nodename(child)
        if tag == "property"
            key = child["name"]
            prop = parse_property(child)
            if "orientation" == key
                orientation = prop.value
            elseif "sizeHint" == key
                size_hint = prop.value
            else
                push!(properties, prop)
            end
        else
            @error "Encountered a '$tag' element while parsing Spacer. Expect 'property' elements"
        end
    end
    Spacer(name, orientation, size_hint, properties)
end

function read_ui_string(text::AbstractString)
    doc = parsexml(text)
    if !hasroot(doc)
        return nothing
    end

    ui = root(doc)
    if nodename(ui) != "ui"
        error("Expected root node to be 'ui' not '$(nodename(ui))'")
    end
    version  = ui["version"]
    children = elements(ui)

    class       = nodecontent(      locatefirst("class", ui))
    root_widget = parse_widget(     locatefirst("widget", ui))
    connections = parse_connections(locatefirst("connections", ui))
    resources   = parse_resources(  locatefirst("resources", ui))

    Ui(class, root_widget, resources, connections, version)
end

"""
Read Qt `.ui` file
"""
function read_ui(stream::IO)
    text = read(stream, String)
    read_ui_string(text)
end

function read_ui(filename::AbstractString)
    open(read_ui, filename)
end

# root = read_ui("testpanel.ui")
# xroot = rootnode("testform.ui")
