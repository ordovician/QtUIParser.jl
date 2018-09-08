export finditem, copyitem!, removeitem!, findfirstitem

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
function findfirstitem(root, name::AbstractString)
    items = finditem(root, name)
    if isempty(items)
        nothing
    else
        first(items)
    end    
end

function finditem(root, kind::DataType)
    finditem(x -> isa(x, kind), root)
end

"""
    finditem(root, name)
Locate an item in the tree. An item could be a layout, widget or spacer
"""
function finditem(root::Union{Ui, Widget, Layout, Spacer}, name::AbstractString)
    finditem(x->x.name == name, root)
end

finditem(pred::Function, ui::Ui) = finditem(pred, ui.root)

function finditem(pred::Function, item::CustomWidget)
    result = Union{Widget, Layout, Spacer}[]
    if pred(item)
        push!(result, item)
    end
    
    append!(result, finditem(pred, item.layout))
end

function finditem(pred::Function, item::Widget)
    if pred(item)
        [item]
    else
        Union{Widget, Layout, Spacer}[]
    end
end

function finditem(pred::Function, layout::Layout)
    result = Union{Widget, Layout, Spacer}[]
    if pred(layout)
        push!(result, layout)
    end
    append!(result, finditem(pred, layout.items))
end

function finditem(pred::Function, items::Vector{T}) where T <: Union{Layout, Widget, Spacer}
    result = Union{Widget, Layout, Spacer}[]
    for item in items
        append!(result, finditem(pred, item))
    end
    result
end


function finditem(pred::Function, spacer::Spacer)
    result = Union{Widget, Layout, Spacer}[]
    if pred(spacer)
        append!(result, [spacer])
    end
    result
end

finditem(pred::Function, ::Nothing) = Union{Widget, Layout, Spacer}[]

"""
    copyitem!(root, source, target)
Copies an item named `source` to layout named `target`. Item can be a widget,
spacer or layout.
"""
function copyitem!(root, item_name::AbstractString, layout_name::AbstractString)
    w = findfirstitem(root, item_name)
    if w == nothing
        error("Did not find any source object named $item_name")
    end

    if !isa(w, Union{Widget, Spacer, Layout})
        error("$item_name is not an item (widget, spacer or layout)")
    end

    layout = findfirstitem(root, layout_name)
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
