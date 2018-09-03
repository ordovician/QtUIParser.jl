using QtUIParser

function Rect(;x, y, width, height)
    Rect(x, y, width, height)
end

function widget_name()
    "widget"
end

box = BoxLayout("layout")

function widget(;args...)
    w = CustomWidget(widget_name(),  "QWidget",  Property[], nothing)
    # name = widget_name()
    # class = "QWidget"
    # properties = Property[]
    # layout = nothing

    for attr in [:name, :class, :layout]
        if haskey(args, attr)
            setfield!(w, attr, args[attr])
            delete!(args, attr)
        end
    end

    for (k, v) in args
        push!(w.properties, property(string(k), v))
    end
end
