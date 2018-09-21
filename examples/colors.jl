Ui(
    class   = "ColorsForm",
    version = "4.0",
    root = QWidget(
        name        = "ColorsForm",
        class       = :QWidget,
        geometry    = Rect(0, 0, 121, 73),
        windowTitle = "Form",
        layout = VBoxLayout(
            name = "top_layout",
            items = [
                QCheckBox("red_box", "red"),
                QCheckBox("blue_box", "blue")
            ]
        )
    )
)