export Resource

# TODO: Define structure
mutable struct Resource

end

function xml(resources::Vector{Resource})
    node = ElementNode("resources")
    for res in resources
        addchild!(node, xml(res))
    end
    node
end
