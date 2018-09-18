import Base: getindex, setindex!, get, delete!,
       length, iterate, 
       getproperty, setproperty!, 
       haskey, isempty,
       union,
       copy
       
export Assoc

"Dictionary implemented as associative list for doing lookups with either key or value"
mutable struct Assoc{K, V} <: AbstractDict{K,V}
    items::Vector{Pair{K, V}}
end

"""
    Assoc(pairs...)
Create an associative list, where you can lookup using either key or value.

# Example
```julia
julia> a = Assoc(Foo => "bar", Egg => "spam")
Assoc(Pair{DataType,String}[Foo=>"bar", Egg=>"spam"])

julia> a[Foo]
"bar"

julia> a["bar"]
Foo
```
"""
Assoc(items...) = Assoc(collect(items))

Assoc{K,V}() where {K,V} = Assoc(Pair{K, V}[])

function getindex(a::Assoc{K, V}, key::K) where {K, V}
    for item in a.items
        if first(item) == key
            return last(item)
        end
    end
    error("No pair where key $key exist")
end

# Reverse lookup. Lookup using value instead of key
function value_lookup(a::Assoc{K, V}, value::V) where {K, V}
    for item in a.items
        if last(item) == value
            return first(item)
        end
    end
    error("No pair where value $value exist")
end

getindex(a::Assoc{Symbol, String}, key::AbstractString) = value_lookup(a, key)

function setindex!(a::Assoc{K, V}, value::V, key::K) where {K, V}
    i = findfirst(x->first(x) == key, a.items)
    if i == nothing
        push!(a.items, key => value)
    else
        a.items[i] = key => value
    end
end

length(a::Assoc)     = length(a.items)
isempty(a::Assoc)    = isempty(a.items)
iterate(a::Assoc)    = iterate(a.items)
iterate(a::Assoc, i) = iterate(a.items, i)
copy(a::Assoc)       = Assoc(copy(a.items))

function get(a::Assoc{K, V}, key::K, default::V) where {K, V}
    i = findfirst(x->first(x) == key, a.items)
    if i == nothing
        default
    else
       last(a.items[i])
    end    
end

function delete!(a::Assoc{K, V}, key::K) where {K, V}
    i = findall(x->first(x) == key, a.items)
    deleteat!(a.items, i)
    a
end

function getproperty(a::Assoc{Symbol, V}, key::Symbol) where V
    if key == :items
        getfield(a, :items)
    else
        a[key]
    end
end

function setproperty!(a::Assoc{Symbol, V}, key::Symbol, value::V) where V
    if key == :items
        setfield!(a, :item, value)
    else
        a[key] = value
    end
end

function haskey(a::Assoc{K, V}, key::K) where {K, V}
    i = findfirst(x->first(x) == key, a.items)
    return i != nothing
end
