Ui(
    class = "ColorSelectorDialog",
    version = "4.0",
    root = Widget(
        name = "ColorSelectorDialog",
        class = "QWidget",
        geometry = Rect(0, 0, 362, 262),
        windowTitle = "Depth Convert Seismic",
        layout = BoxLayout(
            name = "verticalLayout",
            orientation = VERTICAL,
            items = [
                BoxLayout(
                    name = "config_layout",
                    orientation = HORIZONTAL,
                    items = [
                        BoxLayout(
                            name = "name_layout",
                            orientation = VERTICAL,
                            items = [
                                Label("name_label", "color name"),
                                LineEdit("name_edit", ""),
                                CheckBox("alpha_box", "alpha channel"),
                                Spacer("verticalSpacer_2", VERTICAL, Size(20, 40))
                            ]
                        ),
                        GridLayout(
                            name = "color_layout",
                            items = [
                                GridItem(0, 0,
                                    ComboBox("mode_combo", ["RGB", "HSB"])),
                                GridItem(1, 0,
                                    Label("red_label", "red")),
                                GridItem(1, 1,
                                    Slider("red_slider", HORIZONTAL)),
                                GridItem(1, 2,
                                    SpinBox("red_spinner")),
                                GridItem(2, 0,
                                    Label("green_label", "green")),
                                GridItem(2, 1,
                                    Slider("green_slider", HORIZONTAL)),
                                GridItem(2, 2,
                                    SpinBox("green_spinner")),
                                GridItem(3, 0,
                                    Label("blue_label", "blue")),
                                GridItem(3, 1,
                                    Slider("blue_slider", HORIZONTAL)),
                                GridItem(3, 2,
                                    SpinBox("blue_spinner"))
                            ]
                        )
                    ]
                ),
                Spacer("verticalSpacer", VERTICAL, Size(20, 40)),
                BoxLayout(
                    name = "button_layout",
                    orientation = HORIZONTAL,
                    items = [
                        Spacer("horizontalSpacer", HORIZONTAL, Size(40, 20)),
                        PushButton("undo_btn", "undo"),
                        PushButton("store_btn", "undo"),
                        PushButton("close_button", "close")
                    ]
                )
            ]
        )
    )
)