export load, save, saveas, savepath

loaded_file = nothing
loaded_ui = nothing

"""
    load(path)
Load a Qt `.ui` file and keep track of filename and object loaded so it can be
saved easily with `save()` or `saveas(path)` later.
"""
function load(path::AbstractString)
    global loaded_ui = read_ui(path)
    if loaded_ui != nothing
        global loaded_file = path
    end
    loaded_ui
end

function load()
    load(loaded_file)
end

"""
    saveas(path)
Saves `.ui` file prevously loaded with `load(path)` to a new path
"""
function saveas(path::AbstractString)
    if loaded_ui != nothing
        saveas(path, loaded_ui)
    else
        @warn "Not able to re-save Qt ui file because none was previously loaded"
    end
end

"""
    save()
Saves ui object prevously loaded with `load(path)` to `path`
"""
function save()
    if loaded_ui != nothing
        saveas(loaded_file)
    else
        @error "No previously stored load path"
    end
end

"""
    saveas(path, ui::Ui)
Save `ui` object to `path`
"""
function saveas(path::AbstractString, ui::Ui)
    open(path, "w") do io
        write(io, """<?xml version="1.0" encoding="UTF-8"?>""")
        show(io, xml(ui))
        global loaded_file = path
        global loaded_ui = ui
    end
end

"""
    save(ui::Ui)
Save `ui` object to filepath previously used by `load(path)`
"""
function save(ui::Ui)
    saveas(loaded_file, ui)
end

savepath() = loaded_file
