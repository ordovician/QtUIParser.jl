export finditem, copyitem!, findparentitem, removeitem!, findfirstitem


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

function finditem(root, kind::Symbol)
    finditem(x -> isa(x, QWidget) && x.class == kind, root)
end

"""
    finditem(root, name)
Locate an item in the tree. An item could be a layout, widget or spacer
"""
function finditem(root::Union{Ui, QWidget, Layout, Spacer}, name::AbstractString)
    finditem(x->x.name == name, root)
end

finditem(pred::Function, ui::Ui) = finditem(pred, ui.root)

function finditem(pred::Function, item::QWidget)
    result = Item[]
    if pred(item)
        push!(result, item)
    end
    
    append!(result, finditem(pred, item.layout))
end

function finditem(pred::Function, layout::Layout)
    result = Item[]
    if pred(layout)
        push!(result, layout)
    end
    append!(result, finditem(pred, layout.items))
end

function finditem(pred::Function, items::Vector{T}) where T <: Union{Layout, QWidget, Spacer, GridItem}
    result = Item[]
    for item in items
        append!(result, finditem(pred, item))
    end
    result
end

function finditem(pred::Function, item::GridItem)
    finditem(pred, item.item)
end

function finditem(pred::Function, spacer::Spacer)
    result = Item[]
    if pred(spacer)
        append!(result, [spacer])
    end
    result
end

finditem(pred::Function, ::Nothing) = Item[]

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

    if !isa(w, Item)
        error("$item_name is not an item (widget, spacer or layout)")
    end

    layout = findfirstitem(root, layout_name)
    if layout == nothing || !isa(layout, Layout)
        error("Did not find a layout named '$layout_name'")
    end

    push!(layout.items, w)
    layout.items
end

findparentitem(root::Union{Ui, QWidget, Layout, Spacer}, name::AbstractString) = findparentitem(x->x.name == name, root)

findparentitem(pred::Function, ui::Ui) = findparentitem(pred, ui.root)
findparentitem(pred::Function, item::QWidget) = findparentitem(pred, item.layout)

function findparentitem(pred::Function, layout::Layout)
    for (i, item) in enumerate(layout.items)
        if isa(item, GridItem)
            item = item.item
        end
        
        if pred(item)
            return (layout, i)
        else
            x = findparentitem(pred, item)
            if x != nothing
                return x
            end
        end
    end

    nothing
end

findparentitem(pred::Function, ::Union{Spacer, Nothing, GridItem}) = nothing

"""
    removeitem!(pred, root)
Locate item matching predicate `pred` starting at `root`, then remove it. This requires that
item is actually in some kind of collection.
"""
function removeitem!(pred::Function, root::Union{Ui, QWidget, Layout})
    loc = findparentitem(pred, root)
    if loc != nothing
       parent, i = loc
       deleteat!(parent.items, i)
    else
       nothing
    end
end

"""
    removeitem!(root, name)
Locate item with `name` starting at `root`, then remove it. This requires that
item is actually in some kind of collection.
"""
removeitem!(root::Union{Ui, QWidget, Layout}, name::AbstractString) = removeitem!(x->x.name == name, root)