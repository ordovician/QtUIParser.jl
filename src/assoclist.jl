import Base: getindex, setindex!, get,
       length, iterate, 
       getproperty, setproperty!, 
       haskey, show, isempty,
       union, keys, values
       
export Assoc

"Dictionary implemented as associative list for doing lookups with either key or value"
mutable struct Assoc{K, V}
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
    i = findfirst(a->first(a) == key, a.items)
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

function get(a::Assoc{K, V}, key::K, default::V) where {K, V}
    i = findfirst(a->first(a) == key, a.items)
    if i == nothing
        default
    else
       last(a.items[i])
    end    
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
    i = findfirst(a->first(a) == key, a.items)
    return i != nothing
end

# TODO return iterator
keys(a::Assoc) = first.(a.items)
values(a::Assoc) = last.(a.items)

function show(io::IO, a::Assoc{K, V}) where {K, V}
    print(io, "Assoc(")
    join(io, a.items, ", ")
    print(")")
    # len = length(a)
    # if len == 1
    #    println(io, "Assoc{$K,$V} with $len entry:")
    # else
    #     println(io, "Assoc{$K,$V} with $len entries:")
    # end
    #
    # keys = string(first.(a.items))
    # max_width = maximum(length.(keys))
    #
    # for (k, v) in a.items
    #    sk = "\"$k\""
    #    sk = rpad(sk, max_width + 2)
    #    println(io, "  $sk => $v")
    # end
end