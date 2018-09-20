export finditem, copyitem!, removeitem!, findfirstitem


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

function removeitem!(parent::QWidget, name::AbstractString)
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

function removeitem!(layout::Layout, name::AbstractString)
    if layout.name == name
        nothing
    else
        removeitem!(layout.items, name)
    end
end

function removeitem!(items::Vector{T}, name::AbstractString) where T <: Item
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

function removeitem!(items::Vector{T}, i) where T <: Item
    item = items[i]
    deleteat!(items, i)
    item
end
