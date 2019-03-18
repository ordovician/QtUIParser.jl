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
                        load_root_widget("wellpickstab.jl"),
                        load_root_widget("trajlogstab.jl")
                    ]
                ),
                load_root_widget("info-column.jl")
            ]
        )
    )
)
