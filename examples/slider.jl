Ui(
    class = "SliderForm",
    version = "4.0",
    root = Widget(
        name = "SliderForm",
        class = "QWidget",
        geometry = Rect(0, 0, 175, 110),
        windowTitle = "Form",
        layout = BoxLayout(
            name = "verticalLayout",
            orientation = VERTICAL,
            items = [
                SpinBox("value_spinner"),
                Slider("value_slider", HORIZONTAL)
            ]
        )
    )
)