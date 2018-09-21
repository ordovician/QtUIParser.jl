Ui(
    class   = "ColorSelectorDialog",
    version = "4.0",
    root = QWidget(
        name        = "ColorSelectorDialog",
        class       = :QWidget,
        geometry    = Rect(0, 0, 362, 262),
        windowTitle = "Depth Convert Seismic",
        layout = VBoxLayout(
            name = "verticalLayout",
            items = [
                HBoxLayout(
                    name = "config_layout",
                    items = [
                        VBoxLayout(
                            name = "name_layout",
                            items = [
                                QLabel("name_label", "color name"),
                                QLineEdit("name_edit", ""),
                                QCheckBox("alpha_box", "alpha channel"),
                                Spacer("verticalSpacer_2", VERTICAL, Size(20, 40))
                            ]
                        ),
                        GridLayout(
                            name = "color_layout",
                            items = [
                                GridItem(0, 0,
                                    QComboBox(
                                        name = "mode_combo",
                                        items = [
                                            "RGB",
                                            "HSB"
                                        ]
                                    )),
                                GridItem(1, 0,
                                    QLabel("red_label", "red")),
                                GridItem(1, 1,
                                    QSlider("red_slider", HORIZONTAL)),
                                GridItem(1, 2,
                                    QSpinBox("red_spinner")),
                                GridItem(2, 0,
                                    QLabel("green_label", "green")),
                                GridItem(2, 1,
                                    QSlider("green_slider", HORIZONTAL)),
                                GridItem(2, 2,
                                    QSpinBox("green_spinner")),
                                GridItem(3, 0,
                                    QLabel("blue_label", "blue")),
                                GridItem(3, 1,
                                    QSlider("blue_slider", HORIZONTAL)),
                                GridItem(3, 2,
                                    QSpinBox("blue_spinner"))
                            ]
                        )
                    ]
                ),
                Spacer("verticalSpacer", VERTICAL, Size(20, 40)),
                HBoxLayout(
                    name = "button_layout",
                    items = [
                        Spacer("horizontalSpacer", HORIZONTAL, Size(40, 20)),
                        QPushButton("undo_btn", "undo"),
                        QPushButton("store_btn", "undo"),
                        QPushButton("close_button", "close")
                    ]
                )
            ]
        )
    )
)