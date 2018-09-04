

function Rect(;x, y, width, height)
    Rect(x, y, width, height)
end

function widget_name()
    "widget"
end

box = BoxLayout("layout")

function config_widget!(w::Widget, args)
    for (k, v) in args
        if k in [:name, :class, :layout]
            setfield!(w, k, v)
        else
            push!(w.properties,  QtUIParser.property(string(k), v))
        end
    end
    w
end

function Widget(;args...)
    w = CustomWidget(widget_name(),  "QWidget",  Property[], nothing)
    config_widget!(w, args)
end

types = [:PushButton, :CheckBox, :RadioButton]
for T in types
  @eval begin
      function $T(;args...)
          w = $T("objname", "no label")
          config_widget!(w, args)
      end
  end
end

function BoxLayout(;args...)
    layout = BoxLayout("noname",  QtUIParser.horizontal)
    for (k, v) in args
        if k in [:name, :orientation]
            setfield!(layout, k, v)
        elseif k == :items
            layout.items = v
        else
            push!(layout.properties,  QtUIParser.property(string(k), v))
        end
    end
    layout
end
