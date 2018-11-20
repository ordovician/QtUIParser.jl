import Base: show
export Attributes

function Attributes(;args...)
    if isempty(args)
        Attributes(Assoc{Symbol, String}())
    else
        Attributes(Assoc(args...))
    end
end

function show(io::IO, attributes::Attributes, depth::Integer = 0)
    indent = tab^depth
    if !isempty(attributes.items)
       println(io, "Attributes(")
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
