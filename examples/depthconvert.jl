Ui(
    class   = "DepthConvertPanel",
    version = "4.0",
    root = QWidget(
        name        = "DepthConvertPanel",
        class       = :QWidget,
        geometry    = Rect(0, 0, 505, 263),
        windowTitle = "Depth Convert Seismic",
        layout = VBoxLayout(
            name = "top",
            items = [
                QGroupBox(
                    name = "general",
                    layout = HBoxLayout(
                        name = "general_layout",
                        items = [
                            GridLayout(
                                name = "output_layout",
                                items = [
                                    GridItem(0, 0,
                                        QLabel("name_label", "Output name:")),
                                    GridItem(0, 1,
                                        QLineEdit("name_edit", "Output name:"))
                                ]
                            ),
                            VBoxLayout(
                                name = "type_layout",
                                items = [
                                    QRadioButton("realized", "Realized"),
                                    QRadioButton("preview", "Preview"),
                                    Spacer("type_spacer", VERTICAL, Size(10, 20))
                                ]
                            )
                        ]
                    )
                ),
                GridLayout(
                    name = "cropping_layout",
                    items = [
                        GridItem(0, 0,
                            QCheckBox("depth_crop", "Cropping in depth")),
                        GridItem(2, 0,
                            QLabel("range_label", "Sample range:")),
                        GridItem(1, 1,
                            QLabel("min_label", "Min")),
                        GridItem(2, 1,
                            QLineEdit("min_edit", "0.0")),
                        GridItem(3, 1,
                            QSlider("min_slider", HORIZONTAL)),
                        GridItem(1, 2,
                            QLabel("max_label", "Max")),
                        GridItem(2, 2,
                            QLineEdit("max_edit", "0.0")),
                        GridItem(3, 2,
                            QSlider("max_slider", HORIZONTAL))
                    ]
                )
            ]
        )
    )
)