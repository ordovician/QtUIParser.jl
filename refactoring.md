# Refactoring Plans

The approached followed in this design ended up with too many special cases which has to be handled. Having a different type for each Widget seems to have been mostly a bad idea.

Not having a clear distinction between attributes and properties is another bad idea. This complicates the parsing of the XML file and requires too much specialized code.

So here are some ideas for how to improve the design.


## One Flexible Widget Type
Something like this

    mutable struct Widget
        # Store class, name etc
        attributes::Assoc{String, String}

        # Geometry, size etc
        properties::Assoc{String, Any}
        layout::Union{Layout, Nothing}

        # Primarily for Combobox
        items::Assoc{String, String}
    end
    
The `Assoc` type provides a dictionary interface, but has its items ordered according to when they where added thus preserving order. Internally it is just a list of pairs searched. When the number of items in a collection is small, a linear search will be much faster than a hash table lookup.

The interface to work with these widgets could be something like this:

    w = Widget(...)
    w.attributes["name"] = "ok_button"
    w.properties["geometry"].width = 10
    
    push!(w.items, "red")
    
    w.layout.items["cancel_button"].properties["enabled"] = false
    
Alternatively we implement the `getproperty(vale, name)` and `setproperty!(value, name, x)` to access attributes and properties. A possible problem is a name conflict between attribute and property names. We could use `setindex!()` and `getindex()` to access child widgets. Alternative use a `children()` function.
    
    w.name = "ok_button"
    w.geometry.width = 10
    
    push!(w.items, "red")
    
    w["cancel_button"].enabled = false
    
### Visualization
We want to be able to write things like `PushButton("click me!")` rather than `Widget(class = "QPushButton", text = "click me!")`, and we that is what we want to see visualized. But there is nothing preventing us from doing that even if the underlying data structure is always `Widget`.

We simple define constructors for `Widget` which supports this. 

    for T in [:PushButton, :CheckBox, :RadioButton, :Label, :LineEdit]
      @eval begin
        function $T(name::AbstractString, text::AbstractString = "")
            attributes = Assoc("name"=>name, "class"=>string('Q', $T))
            Widget(attributes, Assoc{String, Any}(), nothing, Assoc{String, String}())
        end
        
        function $T(;args)
            w = $T("name", "label")
            for (k, v) in args
                skey = string(k)
                if k in [:name, :class]
                    w.attributes[skey] = v
                else
                    w.properties[skey] = v
                end
            end
            return w 
        end
      end
    end
    
This will produce constructors which look like constructors for actual types but which really only create `Widget` instances.

We also modify `show(io, widget)` to fake the appearance of custom types.

     function show(io::IO, w::Widget, depth::Integer = 0)
         print(io, w.attributes["class"][2:end], "(")
         for (k, v) in w.properties
             join(io, "$k = $v")
         end
         print(io, ")")
     end