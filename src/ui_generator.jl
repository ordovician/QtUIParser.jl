using PLists

export xml

function xml(p::Property)
    error("Must implement xml(", typeof(p), ")")
end

"""
    xml(connection)
Create an XML representation of a Qt connection between signal and slot
of a sender and receiver.
"""
function xml(conn::Connection)
    node = ElementNode("connection")
    addchildren!(node, [
        "sender" => conn.sender, 
        "signal" => string(conn.signal), 
        "receiver" => conn.receiver, 
        "slot" => string(conn.slot)])
    node   
end

function connection(sender::String, signal::Signal, receiver::String, slot::Slot)
    xml(Connection(sender, signal, receiver, slot))
end

"""
    xml(connections)
XML representation for multiple connections.
"""
function xml(conns::Vector{Connection})
    node = ElementNode("connections")
    for conn in conns 
        addchild!(node, xml(conn))
    end
    node 
end

function connections(conns...)
    p = ElementNode("connections")
    for conn in conns 
        addchild!(p, conn)
    end
    p    
end

function xml(w::Widget)
    error("Must implement xml(", typeof(w), ")")
end

function uiform(name::AbstractString = "Form")
    ElementNode("ui", [AttributeNode("version", "4.0")], [ElementNode("class", name)])
end

function widget(class::AbstractString, name::AbstractString)
    ElementNode("widget", ["class"=>class, "name"=>name])
end

function combobox(name::AbstractString)
    xml(ComboBox(name))
end

function checkbox(name::AbstractString, label::AbstractString)
    xml(CheckBox(name, label))
end

function pushbutton(name::AbstractString, label::AbstractString)
    xml(PushButton(name, label))
end

"""
    xml(boxlayout)
Create XML representation for a vertical or horizontal box layout
"""
function xml(layout::BoxLayout)
    class = if layout.orientation == horizontal
        "QHBoxLayout"
    elseif layout.orientation == vertical
        "QVBoxLayout"
    end
    node = ElementNode("layout", ["class"=>class, "name"=>name])
    for item in layout.items
       addchild!(node, ElementNode("item", [xml(item)]))
    end
    node
end

function boxlayout(name::AbstractString, orientation::Orientation, items...)
    xml(BoxLayout(name, orientation, items))
end

function vboxlayout(name::AbstractString, items...)
    boxlayout(name, vertical, items...)
end

function hboxlayout(name::AbstractString, items...)
    boxlayout(name, horizontal, items...)
end

"""
    xml(ui)
Create XML representation of the top-level object of a Qt `.ui` file.
If you want to write a `.ui` this the XML you need.
"""
function xml(ui::Ui)
    ElementNode("ui", [xml(ui.root_widget), xml(ui.connections)])
end

"""
    class_name(combobox)
Name of combobox class in Qt.
"""
class_name(w::ComboBox) = "QComboBox"

"""
    class_name(radiobutton)
Name of radio button class in Qt.
"""
class_name(w::RadioButton) = "QRadioButton"

"""
    class_name(checkbox)
Name of check box class in Qt.
"""
class_name(w::CheckBox) = "QCheckBox"

"""
    class_name(slider)
Name of slider class in Qt.
"""
class_name(w::Slider) = "QSlider"

"""
    class_name(widget)
Name of widget class in Qt.
"""
class_name(w::Widget) = "QWidget"

"""
    xml(property)
XML representation of a subclass of `Property`. Used to describe aspects
of a widget.
"""
function xml(p::GeometryProperty)
    node = ElementNode("property", ["name"=>"geometry"])
    r = p.rect
    addchildren!(node, [
        "x" => string(r.x), 
        "y" => string(r.y), 
        "width" => string(r.width), 
        "height" => string(r.height)])
    node 
end

function xml(p::TextProperty)
    node = ElementNode("property", ["name"=>"text"])
    addchild!(node, ElementNode("string", p.text))
    node
end

function xml(p::OrientationProperty)
    node = ElementNode("property", ["name"=>"orientation"])
    s = if p.orientation == horizontal
            "Qt::Horizontal"
        elseif p.orientation == vertical
            "Qt::Vertical"
        end        
    addchild!(node, ElementNode("enum", s))
    node
end

function xml(p::BoolProperty)
    node = ElementNode("property", ["name"=>p.name])
    addchild!(node, ElementNode("bool", string(p.on)))
    node
end

function add_property_nodes!(node::Node, w::Widget)
    for p in w.properties
        addchild!(node, xml(p))
    end
end

"""
    xml(widget)
Turn a widget such as a combobox, slider or checkbox into a tree of XML nodes.
"""
function xml(w::ComboBox)
    node = widget(class_name(w), w.name)
    add_property_nodes!(node, w)
    for item in w.items
       addchild!(node, ElementNode("item"), [xml(item)]) 
    end
    node
end

function xml(w::Slider)
    node = widget(class_name(w), w.name)
    add_property_nodes!(node, w)
    node 
end

function xml(w::Union{PushButton, CheckBox, RadioButton})
    node = widget(class_name(w), w.name)
    addchild!(node, xml(property(w.label)))
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
