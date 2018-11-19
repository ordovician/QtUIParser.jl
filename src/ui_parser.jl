using PLists

export read_ui, read_ui_string,
       findproperty, findwidget

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
    if      "Qt::Horizontal" == s
        HORIZONTAL
    elseif "Qt::Vertical" == s
        VERTICAL
    elseif "QSizePolicy::Fixed" == s
        FIXED
    elseif "Qt::AlignRight" == s
        RIGHT
    elseif "Qt::AlignLeft" == s
        LEFT
    elseif "Qt::AlignHCenter" == s
        HCENTER
    elseif "Qt::AlignVCenter" == s
        VCENTER
    elseif "Qt::AlignTrailing" == s
        TRAILING
    elseif "QAbstractSpinBox::UpDownArrows" == s
        UP_DOWN_ARROWS
    elseif "QAbstractSpinBox::PlusMinus" == s
        PLUS_MINUS
    elseif "QAbstractSpinBox::NoButtons" == s
        NO_BUTTONS
    else
        error("Unknown enum value '$s'")
    end
end

function parse_set(s::AbstractString)
    parse_enum.(split(s, '|'))
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
    elseif "number" == tag
        Meta.parse(nodecontent(n))
    elseif "double" == tag              # TODO probably need to distinguish between number and double somehow
        Meta.parse(nodecontent(n))
    elseif "enum" == tag
        parse_enum(nodecontent(n))
    elseif "bool" == tag
        Meta.parse(nodecontent(n))
    elseif "rect" == tag
        parse_rect(n)
    elseif "size" == tag
        parse_size(n)
    elseif "set" == tag
        parse_set(nodecontent(n))
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
    Symbol(name) => parse_property_data(data_node)
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
    value(key) = nodecontent(locatefirst(key, node))

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

"Parses all types of layout."
function parse_layout(node::ElementNode)
    class = node["class"]
    name  = node["name"]

    items = Item[]
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
            colspan = 1
            if haskey(item_node, "colspan")
                colspan = Meta.parse(item_node["colspan"])
            end
            push!(griditems, GridItem(row, col, colspan, item))
        else
            push!(items, item)
        end
    end

    if     "QVBoxLayout" == class
        BoxLayout(name, VERTICAL, items)
    elseif "QHBoxLayout" == class
        BoxLayout(name, HORIZONTAL, items)
    elseif "QGridLayout" == class
        GridLayout(name, griditems)
    else
        @error "Missing code to handle Layout of type '$class'"
    end
end

# TODO: Implement when we know more about the structure of resources XML
function parse_resources(node::ElementNode)
    Resource[]
end

function parse_custom_widget(node::ElementNode)
    value(key) = nodecontent(locatefirst(key, node))

    class  = value("class")
    super  = value("extends")
    path   = value("header")

    CustomWidget(Symbol(class), Symbol(super), path)
end

function parse_custom_widgets(node::ElementNode)
    widgets = elements(node)
    [parse_custom_widget(w) for w in widgets]
end


"Parse item tags found under a widget. Typically this will be a QComboBox"
function parse_widget_item(node::ElementNode)
    prop_nodes = elements(node)
    if isempty(prop_nodes)
       @warn "Expected item to contain a property but it didn't"
       nothing
    else
        n = first(prop_nodes)
        tag = nodename(n)
        if tag != "property"
            @warn "item has a sub node with tag '$tag', but we expect 'property'"
            nothing
        else
            parse_property(n)
        end
    end
end

"Parse any kind of widget. May want to split this up."
function parse_widget(node::ElementNode)
    cname = node["class"] # class name
    name  = node["name"]

    children = elements(node)

    items      = String[]  # In case we are parsing a combobox e.g.
    properties = Assoc{Symbol, Primitive}()
    attributes = Assoc{Symbol, String}()
    layout  = nothing
    widgets = QWidget[]

    for child in children
        tag = nodename(child)
        if     tag == "property"
            push!(properties, parse_property(child))
        elseif tag == "layout"
            layout = parse_layout(child)
        elseif tag == "item"
            item = parse_widget_item(child)
            if item != nothing
                if first(item) == :text
                    push!(items, last(item))
                else
                   @warn "Did not add item of type '$(first(item))' to combobox '$name'"
                end
            end
        elseif tag == "attribute"
            push!(attributes, parse_property(child))
        elseif tag == "widget"
            push!(widgets, parse_widget(child))
        else
            @warn "Not parsing unknown widget tag '$tag'"
        end
    end


    QWidget(name, Symbol(cname), attributes, properties, items, layout, widgets)
end

function parse_spacer(node::ElementNode)
    name  = node["name"]
    children = elements(node)

    properties = Assoc{Symbol, Primitive}()
    for child in children
        tag = nodename(child)
        if tag == "property"
            key = child["name"]
            prop = parse_property(child)
            push!(properties, prop)
        else
            @error "Encountered a '$tag' element while parsing Spacer. Expect 'property' elements"
        end
    end
    Spacer(name, properties)
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
    customwidgets = parse_custom_widgets(locatefirst("customwidgets", ui))

    Ui(class, root_widget, resources, connections, customwidgets, version)
end

"""
    read_ui(stream)
Read Qt `.ui` file from stream
"""
function read_ui(stream::IO)
    text = read(stream, String)
    read_ui_string(text)
end

"""
    read_ui(filename)
Read Qt `.ui` file. Returns a node graph representing UI which can be transformed
to different formats.
"""
function read_ui(filename::AbstractString)
    open(read_ui, filename)
end

# root = read_ui("testpanel.ui")
# xroot = rootnode("testform.ui")
