export xml

function xml(p::Pair{Symbol, T}; tag = "property") where T <: Union{String, Orientation, SizeType, TextFormat, ButtonSymbols, AlignmentSet, Rect, Font, Bool, SizePolicy, Number}
    parent = ElementNode(tag, ["name"=>string(first(p))])
    child  = xml(last(p))
    addchild!(parent, child)
    parent
end

xml(p::Pair; tag = "property") = xml(first(p) => last(p), tag = tag)

function xml(p::Pair{Symbol, Size}; tag = "property")
    parent = ElementNode(tag, ["name"=>string(first(p)), "stdset"=>"0"])
    child  = xml(last(p))
    addchild!(parent, child)
    parent
end

function xml(properties::Assoc{Symbol, T}; tag = "property") where T <: Primitive
   ElementNode[xml(p, tag = tag) for p in properties]
end

function xml(properties::Array{Pair{Symbol, T}}; tag = "property") where T <: Primitive
   ElementNode[xml(p, tag = tag) for p in properties]
end
