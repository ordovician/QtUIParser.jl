export Spacer

function Spacer(name::AbstractString)
    Spacer(name, Assoc{Symbol, Primitive}())    
end

function Spacer(name::AbstractString, orientation::Orientation, sizehint::Size)
    spacer = Spacer(name)
    spacer.properties[:orientationt] = orientation
    spacer.properties[:size_hint] = sizehint
    spacer
end

function Spacer(;args)
    spacer = Spacer("noname")
    
    for (k, v) in args
        if k in fieldnames(typeof(spacer))
            setfield!(spacer, k, v)
        else
            spacer.properties[k] = v
        end
    end
    spacer
end


function show(io::IO, spacer::Spacer, depth::Integer = 0)
    indent = tab^depth
    
    if get(io, :indent, true)
        print(io, indent)
    end
    
    io = IOContext(io, :indent => true)
    
    println(io, "Spacer(")
    traits = Any[:name => spacer.name]
    pretty_print_collection(io, union(traits, spacer.properties), 
                            depth + 1)
    println(io)
    print(io, indent, ")")
end


