import Base: print, show, setindex!, getindex, haskey, keys, iterate, length

using PLists

export xml

abstract type Widget end
abstract type Layout end
abstract type Property end

# How much indentation to use for each indentation level
const tab = "    "
