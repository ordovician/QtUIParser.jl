export Property, property   

struct Property
    name::String
    value::Union{String, Orientation, Rect, Size, Bool}
end

property(text::AbstractString)     = Property("text", text)
property(orientation::Orientation) = Property("orientation", orientation)
property(rect::Rect)               = Property("geometry", rect)

function property(name::AbstractString, value::Union{String, Orientation, Rect, Size, Bool})
    Property(name, value)
end

"Get the value of the property, regardless of whether it is boolean, text or orientation"
propvalue(p::Property) = p.value

##################### IO #####################

function show(io::IO, prop::Property, depth::Integer = 0)
    print(io, tab^depth)
    print(io, prop.name, " = ")
    show(io, propvalue(prop))
end

function show(io::IO, properties::Vector{T}, depth::Integer = 0) where T <: Property
    if !isempty(properties)
        for prop in properties[1:end-1]
            show(io, prop, depth)
            println(io, ",")
        end
        show(io, properties[end], depth)
    end
end

##################### XML #####################
function xml(p::Property)
    parent = ElementNode("property", ["name"=>p.name])
    child  = xml(p.value)
    addchild!(parent, child)
    parent
end
