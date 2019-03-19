function Tab(tabname::AbstractString, filename::AbstractString)
    w = load_root_widget(filename)
    w.attributes.items[:title] = tabname
    w
end

Ui(
    class   = "HUMForm",
    version = "4.0",
    root = QWidget(
        name     = "humpanel",
        class    = :QWidget,
        layout = HBoxLayout(
            name = "top_column_layout_",
            items = [
                load_root_widget("data-selection-column.jl"),
                QWidget(
                    name         = "main_tab_widget_",
                    class        = :QTabWidget,
                    currentIndex = 1,
                    children = [
                        Tab("Horizons and Intervals", "horizonstab.jl"),
                        Tab("Wellpicks", "wellpickstab.jl"),
                        Tab("Trajectories and logs", "trajlogstab.jl")
                    ]
                ),
                load_root_widget("info-column.jl")
            ]
        )
    )
    customwidgets = [
        CustomWidget(:WObjectsSelector, :QWidget, "panel/ui/wobjectsselector.h"),
        CustomWidget(:QtCompComboBox, :QComboBox, "uiqt/qtcompcombobox.h")
    ]
)
