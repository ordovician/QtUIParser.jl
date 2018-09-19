##################### XML #####################

function xml(r::Rect)
    parent = ElementNode("rect")

    addchildren!(parent, [
        "x" => string(r.x),
        "y" => string(r.y),
        "width" => string(r.width),
        "height" => string(r.height)])
    parent
end

function xml(sz::Size)
    parent = ElementNode("size")

    addchildren!(parent, [
        "width"  => string(sz.width),
        "height" => string(sz.height)])
    parent
end

function xml(orientation::Orientation)
    s = if orientation == HORIZONTAL
            "Qt::Horizontal"
        elseif orientation == VERTICAL
            "Qt::Vertical"
        end
    ElementNode("enum", s)
end

xml(on::Bool) = ElementNode("bool", string(on))
xml(text::AbstractString) = ElementNode("string", text)
xml(num::Number) = ElementNode("number", string(num))