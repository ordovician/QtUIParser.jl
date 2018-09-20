Ui( class = "ButtonsPanel",
    version = "4.0",
    root = QWidget(
        class = "QWidget",
        name = "ButtonForm",
        geometry = Rect(0, 0, 180, 150),
        windowTitle = "Choose Colors",
        layout = BoxLayout(
            name = "top_vlayout",
            orientation = VERTICAL,
            items = [
                CheckBox("red_checkbox", "red"),
                CheckBox("green_checkbox", "green"),
                Spacer("vertical_spacer", VERTICAL, Size(20, 40)),
                BoxLayout(
                    name = "bottom_hlayout",
                    orientation = HORIZONTAL,
                    items = [
                        PushButton("ok_button", "Ok"),
                        PushButton("ok_button", "Cancel")
                    ]
                )
            ]
        )
    )
)
