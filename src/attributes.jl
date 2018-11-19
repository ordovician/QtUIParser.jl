import Base: show
import QtUIParser: xml
export Attributes

"""
Used to store attributes of widgets. Not a very useful type. Mainly used to be
able to distingush properties and attributes typewise.
"""
mutable struct Attributes
    items::Assoc{Symbol, String}
end

Attributes(;args...) = Attributes(Assoc(args...))

function show(io::IO, attributes::Attributes, depth::Integer = 0)
    indent = tab^depth
    if !isempty(attributes.items)
       println(io, ",")
       println(io, indent, "attributes = Attributes(")
       pretty_print_collection(io, attributes.items, depth + 1)
       println(io)
       print(io, indent, ")")
    end
end

##################### XML #####################
function xml(attributes::Attributes)
    map(attributes.items.items) do attr
        parent = ElementNode("attribute", ["name"=>string(first(attr))])
        child  = xml(last(attr))
        addchild!(parent, child)
        parent
    end
end
