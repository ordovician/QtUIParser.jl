Ui(
    class = "ColorsForm",
    version = "4.0",
    root = Widget(
        name = "ColorsForm",
        class = "QWidget",
        geometry = Rect(0, 0, 121, 73),
        windowTitle = "Form",
        layout = BoxLayout(
            name = "top_layout",
            orientation = VERTICAL,
            items = [
                CheckBox("red_box", "red"),
                CheckBox("blue_box", "blue")
            ]
        )
    )
)