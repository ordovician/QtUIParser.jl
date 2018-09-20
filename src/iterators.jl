struct PropertyIterator
    widget::QWidget
end

function iterate(it::PropertyIterator)
    props = it.widget.properties
    if isempty(props)
        nothing
    else
        (propvalue(props[1]), 2)
    end
end

function iterate(it::PropertyIterator, i)
    props = it.widget.properties
    if i > lastindex(props)
        nothing
    else
        (propvalue(prop[i]), i+1)
    end
end

function length(it::PropertyIterator)
    length(it.widget.properties)
end

function keys(w::QWidget)
    PropertyIterator(w)
end

# function show(io::IO, it::PropertyIterator)
#     value = collect(it)
# end
