import Base: print, show, setindex!, getindex, haskey, keys, iterate, length

using PLists

export Rect, Size, SizePolicy,
       Orientation, HORIZONTAL, VERTICAL,
       SizeType, PREFERRED, EXPANDING, FIXED,
       Alignment, RIGHT, LEFT, HCENTER, VCENTER, TRAILING,
       Primitive,
       QWidget, Spacer, Layout, Item 

abstract type Layout end

"Sliders and box layouts may have orientations"
@enum Orientation HORIZONTAL VERTICAL
@enum SizeType PREFERRED EXPANDING FIXED
@enum Alignment RIGHT LEFT HCENTER VCENTER TRAILING

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

Primitive = Union{String, Orientation, Rect, Size, Bool, SizePolicy, Number}

"Typically used for custom top level widgets"
mutable struct QWidget
    name::String
    class::Symbol
    attributes::Assoc{Symbol, String}
    properties::Assoc{Symbol, Primitive}
    items::Vector{String}
    layout::Union{Layout, Nothing}
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

struct GridItem
    row::Int
    column::Int
    item::Item
end

mutable struct GridLayout <: Layout
   name::String
   properties::Assoc{Symbol, Primitive}
   items::Vector{GridItem}
end

# How much indentation to use for each indentation level
const tab = "    "

