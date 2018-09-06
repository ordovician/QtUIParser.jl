import Base: print, show, setindex!, getindex, haskey, keys, iterate, length

export Ui,
       Widget, Spacer, Layout, Property, Signal, Slot, Connection, Resource,
       Orientation, HORIZONTAL, VERTICAL,
       Rect, Size,
       PushButton, CheckBox, RadioButton, Slider, ComboBox,
       CustomWidget,
       TextProperty, BoolProperty, GeometryProperty, OrientationProperty,
       BoxLayout

"Define the placement and size of a widget. Used for the geometry property"
struct Rect
    x::Int
    y::Int
    width::Int
    height::Int
end

struct Size
    width::Int
    height::Int
end

abstract type Widget end
abstract type Layout end
abstract type Property end



"Sliders and box layouts may have orientations"
@enum Orientation HORIZONTAL VERTICAL

struct TextProperty <: Property
   name::String
   value::String
end

property(text::AbstractString) = TextProperty("text", text)

struct OrientationProperty <: Property
    name::String
    value::Orientation
end

property(orientation::Orientation) = OrientationProperty("orientation", orientation)

struct GeometryProperty <: Property
    name::String
    value::Rect
end

struct SizeProperty <: Property
    name::String
    value::Size
end

property(rect::Rect) = GeometryProperty("geometry", rect)

struct BoolProperty <: Property
    name::String
    value::Bool
end

"Get the value of the property, regardless of whether it is boolean, text or orientation"
propvalue(p::Property) = p.value

types = [:PushButton, :CheckBox, :RadioButton]
for T in types
  @eval begin
    mutable struct $T <: Widget
        name::String
        text::String
        properties::Vector{Property}
    end
    $T(name::AbstractString, text::AbstractString = "") = $T(name, text, Property[])
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
    items::Vector{Property}
end

function ComboBox(name::AbstractString, items::Array{T} = T[]) where T <: AbstractString
    ComboBox(name, Property[], items)
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

mutable struct Spacer
    name::String
    orientation::Orientation
    size_hint::Size
    properties::Vector{Property}
end

"""
     Spacer(name, orientation, size_hint)
Creates a strech or space inside a layout. It can be used to expand empty
space, avoiding that other GUI components are made bigger.
"""
function Spacer(name, orientation, size_hint)
    Spacer(name, orientation, size_hint, Property[])
end

"A layout which lays out items vertical or horizontal depending on `orientation`"
mutable struct BoxLayout <: Layout
    name::String
    orientation::Orientation
    items::Vector{Union{Layout, Widget, Spacer}}
end

function BoxLayout(name::AbstractString, orientation::Orientation = HORIZONTAL)
    BoxLayout(name, orientation, Union{Layout, Widget, Spacer}[])
end


"""
Defines a signal which may be broadcast from a QObject. Looks like
a C++ function signature. E.g. we would represent the signal:

    add(int, int)

Like this:

    Signal("add", ["int", "int"])
"""
struct Signal
    name::String
    args::Vector{String}
end

Signal(name::AbstractString) = Signal(name, String[])

"""
Defines a slot on a QObject which may accept a broadcast signal.
Looks like a regular C++ function:

    add(int, int)

Like this:

    Slot("add", ["int", "int"])
"""
struct Slot
    name::String
    args::Vector{String}
end

Slot(name::AbstractString) = Slot(name, String[])

"""
Represent a connection between a signal emitted from an object
and a slot on a receiving object. This could be a push button emitting
a `clicked()` signal, which you want to connect to a `handleButtonClick()`
slot on receiver object.
"""
mutable struct Connection
    sender::String
    signal::Signal
    receiver::String
    slot::Slot
end

# TODO: Define structure
mutable struct Resource

end

"""
All `.ui` files need to be made with a `Ui` object at the top.
`root_widget` is the root of the widget hierarchy, defining the GUI.
`connections` contains the connections between widgets found in this
hierarchy.
"""
mutable struct Ui
    class::String
    root_widget::Widget
    resources::Array{Resource}
    connections::Array{Connection}
    version::String
end

function Ui(class::AbstractString = "Form")
    Ui(class, CustomWidget(class), Resource[], Connection[], "4.0")
end

function Ui(root::Widget)
    Ui(root.name, root, Resource[], Connection[], "4.0")
end

"""
Creates a property named `name`. The concrete `Property` type used will
depend on the type of value provided.

    property(name, rect)
Create a property holding a rectangle. Used to represent the geometry of a widget.
"""
property(name::AbstractString, r::Rect) = GeometryProperty(name, r)

property(name::AbstractString, sz::Size) = SizeProperty(name, sz)

"""
    property(name, text)
Text property which can be used for e.g. a window title or label of a widget.
"""
property(name::AbstractString, text::AbstractString) = TextProperty(name, text)

"""
    property(name, orientation)
Orientation of a widget. E.g. is the slider horizontal or vertical.
"""
property(name::AbstractString, orientation::Orientation) = OrientationProperty(name, orientation)

"""
    property(name, on)
Boolean property. Useful for the state of check boxes or radio buttons.
"""
property(name::AbstractString, on::Bool) = BoolProperty(name, on)



print(io::IO, signal::Signal) = print(io, signal.name, "(", join(signal.args, ", "),")")
print(io::IO, slot::Slot)     = print(io, slot.name,   "(", join(slot.args,   ", "),")")

function getindex(w::Widget, key::AbstractString)
    for p in w.properties
        if p.name == key
            return p
        end
    end
    error("No property with key $key exist")
end

function setindex!(w::Widget, value, key::AbstractString)
    i = findfirst(w->w.name == key, w.properties)
    if i == nothing
        push!(w.properties, property(key, value))
    else
        w.properties[i] = property(key, value)
    end
end

struct PropertyIterator
    widget::Widget
end

function iterate(it::PropertyIterator)
    props = it.widget.properties
    if isempty(props)
        nothing
    else
        (propvalue(props[1]), 2)
    end
end

function iterate(it::PropertyIterator, i)
    props = it.widget.properties
    if i > lastindex(props)
        nothing
    else
        (propvalue(prop[i]), i+1)
    end
end

function length(it::PropertyIterator)
    length(it.widget.properties)
end

function keys(w::Widget)
    PropertyIterator(w)
end

# function show(io::IO, it::PropertyIterator)
#     value = collect(it)
# end
