export xml

function xml(p::Pair{Symbol, T}; tag = "property") where T <: Primitive
    parent = ElementNode(tag, ["name"=>string(first(p))])
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
