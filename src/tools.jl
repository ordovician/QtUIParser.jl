export load, save_ui, save_ui_as, ui_filepath, ui_file,
       erml_filepath, save_erml_as, save_erml, erml_file


ui_file = nothing
erml_file = nothing
loaded_ui = nothing

"""
    load(path)
Load a Qt `.ui` file and keep track of filename and object loaded so it can be
saved easily with `save()` or `saveas(path)` later.
"""
function load(path::AbstractString)
    base, ext = splitext(path)
    if ext == ".ui"
        global loaded_ui = read_ui(path)
        if loaded_ui != nothing
            global ui_file = path
            global erml_file = base * ".jl"
        end
    elseif ext == ".jl"
        global loaded_ui = include(path)
        if loaded_ui != nothing
           global erml_file = path
           global ui_file   = base * ".ui" 
        end
    end
    loaded_ui
end

function load()
    load(ui_file)
end

"""
    save_ui_as(path)
Saves `.ui` file prevously loaded with `load(path)` to a new path
"""
function save_ui_as(path::AbstractString)
    if loaded_ui != nothing
        save_ui_as(path, loaded_ui)
    else
        @warn "Not able to re-save Qt ui file because none was previously loaded"
    end
end

"""
    save_ui()
Saves ui object prevously loaded with `load(path)` to `path`
"""
function save_ui()
    if loaded_ui != nothing
        save_ui_as(ui_file)
    else
        @error "No previously stored load path"
    end
end

"""
    save_ui_as(path, ui::Ui)
Save `ui` object to `path`
"""
function save_ui_as(path::AbstractString, ui::Ui)
    open(path, "w") do io
        println(io, """<?xml version="1.0" encoding="UTF-8"?>""")
        show(io, xml(ui))
        global ui_file = path
        global loaded_ui = ui
    end
end

"""
    save_ui(ui::Ui)
Save `ui` object to filepath previously used by `load(path)`
"""
function save_ui(ui::Ui)
    save_ui_as(ui_file, ui)
end

ui_filepath() = ui_file
erml_filepath() = erml_file

"""
    save_erml_as(path)
Saves `.jl` file prevously loaded with `load(path)` to a new path
"""
function save_erml_as(path::AbstractString)
    if loaded_ui != nothing
        save_erml_as(path, loaded_ui)
    else
        @warn "Not able to re-save Qt `.jl` file because none was previously loaded"
    end
end

"""
    save_erml()
Saves ui object prevously loaded with `load(path)` to `path`
"""
function save_erml()
    if loaded_ui != nothing
        save_erml_as(erml_file)
    else
        @error "No previously stored load path"
    end
end

"""
    save_erml_as(path, ui::Ui)
Save `ui` object to `path` in ERML format. ERML is a julia DSL, so file ending should be .jl
"""
function save_erml_as(path::AbstractString, ui::Ui)
    open(path, "w") do io
        show(io, ui)
        global erml_file = path
        global loaded_ui = ui
    end  
end