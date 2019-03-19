module QtUIParser

include("assoclist.jl")
include("core.jl")             # Core data types used  

include("xml.jl")

include("primitives.jl")

include("attributes.jl")
include("widgets.jl")
include("spacer.jl")
include("layouts.jl")

include("signals_and_slots.jl")
include("resources.jl")
include("customwidgets.jl")
include("ui.jl")

include("ui_parser.jl")         # read a .ui file
include("search.jl")            # locating item in the widget hierarchy
include("tools.jl")             # loading and saving .ui and ERML files
include("prefab.jl")            # handy composite widgets

end # module
