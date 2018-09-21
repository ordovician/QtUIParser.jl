Ui(
    class   = "ButtonForm",
    version = "4.0",
    root = QWidget(
        name        = "ButtonForm",
        class       = :QWidget,
        geometry    = Rect(0, 0, 180, 150),
        windowTitle = "Choose Colors",
        layout = VBoxLayout(
            name = "top_vlayout",
            items = [
                QCheckBox("red_checkbox", "red"),
                QCheckBox("green_checkbox", "green"),
                Spacer("vertical_spacer", VERTICAL, Size(20, 40)),
                HBoxLayout(
                    name = "bottom_hlayout",
                    items = [
                        QPushButton("ok_button", "Ok"),
                        QPushButton("cancel_button", "Cancel")
                    ]
                )
            ]
        )
    )
)