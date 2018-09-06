import Base: getindex, setindex!, length, iterate

"Dictionary implemented as associative list for doing lookups with either key or value"
mutable struct Assoc
    items::Array{Pair{DataType, String}}
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

function getindex(a::Assoc, key::AbstractString)
    for item in a.items
        if last(item) == key
            return first(item)
        end
    end
    error("No pair with key $key exist")
end

function setindex!(a::Assoc, value, key::AbstractString)
    i = findfirst(a->last(a) == key, a.items)
    if i == nothing
        push!(a.items, value => key)
    else
        a.items[i] = value => key
    end
end

function getindex(a::Assoc, key::DataType)
    for item in a.items
        if first(item) == key
            return last(item)
        end
    end
    error("No pair with key $key exist")
end

function setindex!(a::Assoc, value, key::DataType)
    i = findfirst(a->first(a) == key, a.items)
    if i == nothing
        push!(a.items, value => key)
    else
        a.items[i] = value => key
    end
end

length(a::Assoc)     = length(a.items)
iterate(a::Assoc)    = iterate(a.items)
iterate(a::Assoc, i) = iterate(a.items, i)
