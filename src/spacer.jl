export Spacer

function Spacer(name::AbstractString)
    Spacer(name, Assoc{Symbol, Primitive}())
end

function Spacer(name::AbstractString, orientation::Orientation, sizehint::Size)
    spacer = Spacer(name)
    spacer.properties[:orientation] = orientation
    spacer.properties[:sizeHint] = sizehint
    spacer
end

function Spacer(;args...)
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

##################### IO #####################

function show(io::IO, spacer::Spacer, depth::Integer = 0)
    indent = tab^depth

    if get(io, :indent, true)
        print(io, indent)
    end

    io = IOContext(io, :indent => true)

    traits = Any[:name => spacer.name]
    properties = Assoc{Symbol, Primitive}()

    for (k, v) in spacer.properties
       if k in [:orientation, :sizeHint]
           push!(traits, k => v)
       else
           push!(properties.items, k => v)
       end
    end

    print(io, "Spacer")

    if isempty(properties)
        print(io, "(")
        join( io, repr.(last.(traits), context = IOContext(io, :compact => true)), ", ")
        print(io, ")")
    else
        println(io, "(")
        pretty_print_collection(io, union(traits, properties),
                                depth + 1)
        println(io)
        print(io, indent, ")")
    end
end

##################### XML #####################
function xml(spacer::Spacer)
    node =  ElementNode("spacer", ["name"=>spacer.name])
    node.children = xml(spacer.properties)
    node
end
