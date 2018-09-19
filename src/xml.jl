export xml

function xml(p::Pair{Symbol, T}) where T <: Primitive
    parent = ElementNode("property", ["name"=>string(first(p))])
    child  = xml(last(p))
    addchild!(parent, child)
    parent    
end

function xml(properties::Assoc{Symbol, T}) where T <: Primitive
   ElementNode[xml(p) for p in properties] 
end

function xml(properties::Array{Pair{Symbol, T}}) where T <: Primitive
   ElementNode[xml(p) for p in properties] 
end