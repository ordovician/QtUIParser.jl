export Layout,
       BoxLayout, VBoxLayout, HBoxLayout,
       GridLayout, GridItem


function BoxLayout(name::AbstractString, orientation::Orientation = HORIZONTAL)
    a = Assoc{Symbol, Primitive}()
    a[:orientation] = orientation
    BoxLayout(name, a, Item[])
end

VBoxLayout(name) = BoxLayout(name, VERTICAL)
HBoxLayout(name) = BoxLayout(name, HORIZONTAL)


GridLayout(name::AbstractString) = GridLayout(name, GridItem[])

function config_layout!(l::Layout, args)
    for (k, v) in args
        if k == :items
            l.items = v
        elseif k in fieldnames(typeof(l))
            setfield!(l, k, v)
        else
            l.properties[k] = v
        end
    end
    l
end

for T in [:BoxLayout, :GridLayout]
    @eval begin
      function $T(;args...)
          layout = $T("noname")
          config_layout!(layout, args)
      end
    end
end

##################### IO #####################

function show(io::IO, item::GridItem, depth::Integer)
    indent = tab^depth
    println(io, indent, "GridItem($(item.row), $(item.column),")
    show(io, item.item, depth + 1)
    print(io, ")")
end

function show(io::IO, layout::Layout, depth::Integer = 0)
    indent = tab^depth
    
    if get(io, :indent, true)
        print(io, indent)
    end
    
    io = IOContext(io, :indent => true)
    
    println(io, "$(typeof(layout))(")
    traits = Any[:name => layout.name]
    pretty_print_collection(io, union(traits, layout.properties), 
                            depth + 1)
    pretty_print_items(io, layout.items, depth + 1)
    println(io)
    print(io, indent, ")")
end




