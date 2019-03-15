import Base: print, show, setindex!, getindex, haskey, keys, iterate, length

using PLists

export Rect, Size, SizePolicy, Font,
       Orientation, HORIZONTAL, VERTICAL,
       SizeType, PREFERRED, EXPANDING, FIXED,
       Alignment, RIGHT, LEFT, HCENTER, VCENTER, TRAILING, LEADING, TOP,
       ButtonSymbols, UP_DOWN_ARROWS, PLUS_MINUS, NO_BUTTONS,
       TextFormat, PLAIN_TEXT,
       Primitive,
       QWidget, Spacer, Layout, Item

abstract type Layout end

"Sliders and box layouts may have orientations"
@enum Orientation HORIZONTAL VERTICAL
@enum SizeType PREFERRED EXPANDING FIXED
@enum Alignment RIGHT LEFT HCENTER VCENTER TRAILING LEADING TOP
@enum ButtonSymbols UP_DOWN_ARROWS PLUS_MINUS NO_BUTTONS
@enum TextFormat PLAIN_TEXT

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

struct SizePolicy
    hsizetype::SizeType
    vsizetype::SizeType
    horstretch::Int
    verstretch::Int
end

struct Font
    pointsize::Int
end

"""
Used to store attributes of widgets. Not a very useful type. Mainly used to be
able to distingush properties and attributes typewise.
"""
mutable struct Attributes
    items::Assoc{Symbol, String}
end

AlignmentSet = Vector{Alignment}

Primitive = Union{String, Orientation, SizeType, ButtonSymbols, AlignmentSet, Rect, Size, Font, TextFormat, Bool, SizePolicy, Number}


"Typically used for custom top level widgets"
mutable struct QWidget
    name::String
    class::Symbol
    attributes::Attributes
    properties::Assoc{Symbol, Primitive}
    items::Vector{String}
    layout::Union{Layout, Nothing}
    children::Vector{QWidget}
end

mutable struct Spacer
    name::String
    properties::Assoc{Symbol, Primitive}
end

Item = Union{Layout, Spacer, QWidget}

"A layout which lays out items vertical or horizontal depending on `orientation`"
mutable struct BoxLayout <: Layout
    name::String
    properties::Assoc{Symbol, Primitive}
    items::Vector{Item}
end

mutable struct GridItem
    row::Int
    column::Int
    rowspan::Int
    colspan::Int
    item::Item
end

GridItem(row::Integer, column::Integer, item::Item) = GridItem(row, column, 1, 1, item)

mutable struct GridLayout <: Layout
   name::String
   properties::Assoc{Symbol, Primitive}
   items::Vector{GridItem}
end

# How much indentation to use for each indentation level
const tab = "    "
