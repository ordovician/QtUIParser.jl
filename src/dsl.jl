export finditem, copyitem!, removeitem!

function Ui(;class = "Form", version =  "4.0", root = CustomWidget(class))
    Ui(class, root, Resource[], Connection[], version)
end


function Rect(;x, y, width, height)
    Rect(x, y, width, height)
end

function widget_name()
    "widget"
end

function config_widget!(w::Widget, args)
    for (k, v) in args
        if k in fieldnames(typeof(w))
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
    layout = BoxLayout("noname",  QtUIParser.HORIZONTAL)
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

################## Search Functionality ############################

"""
    finditem(root, name)
Locate an item in the tree. An item could be a layout, widget or spacer
"""
finditem(ui::Ui, name::AbstractString) = finditem(ui.root, name)

function finditem(item::CustomWidget, name::AbstractString)
    if item.name == name
        item
    else
        finditem(item.layout, name)
    end
end

function finditem(item::Widget, name::AbstractString)
    if item.name == name
        item
    else
        nothing
    end
end

function finditem(layout::Layout, name::AbstractString)
    if layout.name == name
        layout
    else
        finditem(layout.items, name)
    end
end

function finditem(items::Vector{T}, name::AbstractString) where T <: Union{Layout, Widget, Spacer}
    for item in items
        w = finditem(item, name)
        if w != nothing
            return w
        end
    end
    nothing
end


finditem(spacer::Spacer, name) = spacer.name == name ? spacer : nothing
finditem(::Nothing, name) = nothing

"""
    copyitem!(root, source, target)
Copies an item named `source` to layout named `target`. Item can be a widget,
spacer or layout.
"""
function copyitem!(root, item_name::AbstractString, layout_name::AbstractString)
    w = finditem(root, item_name)
    if w == nothing
        error("Did not find any source object named $item_name")
    end

    if !isa(w, Union{Widget, Spacer, Layout})
        error("$item_name is not an item (widget, spacer or layout)")
    end

    layout = finditem(root, layout_name)
    if layout == nothing || !isa(layout, Layout)
        error("Did not find a layout named '$layout_name'")
    end

    push!(layout.items, w)
    layout.items
end


"""
    removeitem!(root, name)
Removes item named `name` located under in a tree starting from `root`.
Returns the item removed in case one wants to put it somewhere else.
"""
function removeitem!(ui::Ui, name::AbstractString)
    if ui.root.name == name
        nothing
    else
        removeitem!(ui.root, name)
    end
end

unequal(a, b) = a != b
unequal(a) = Base.Fix2(unequal, a)

function removeitem!(parent::CustomWidget, name::AbstractString)
    if parent.name == name
        nothing
    elseif parent.layout.name == name
        layout = parent.layout
        parent.layout = nothing
        layout
    else
        removeitem!(parent.layout, name)
    end
end

function removeitem!(item::Widget, name::AbstractString)
    if item.name == name
        item
    else
        nothing
    end
end

function removeitem!(layout::Layout, name::AbstractString)
    if layout.name == name
        nothing
    else
        removeitem!(layout.items, name)
    end
end

function removeitem!(items::Vector{T}, name::AbstractString) where T <: Union{Layout, Widget, Spacer}
    for (i, item) in enumerate(items)
        if item.name == name
            return removeitem!(items, i)
        else
            x = removeitem!(item, name)
            if x != nothing
                return x
            end
        end
    end
end

removeitem!(spacer::Spacer, name) = nothing
removeitem!(::Nothing, name) = nothing

"""
    removeitem!(layout_or_items, index)
Remove item at given index.
Returns the item removed in case one wants to put it somewhere else.
"""
function removeitem!(layout::Layout, i)
    remoteitem(layout.items, i)
end

function removeitem!(items::Vector{T}, i) where T <: Union{Layout, Widget, Spacer}
    item = items[i]
    deleteat!(items, i)
    item
end
