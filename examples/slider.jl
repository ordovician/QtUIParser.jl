Ui(
    class   = "SliderForm",
    version = "4.0",
    root = QWidget(
        name        = "SliderForm",
        class       = :QWidget,
        geometry    = Rect(0, 0, 175, 110),
        windowTitle = "Form",
        layout = VBoxLayout(
            name = "verticalLayout",
            items = [
                QSpinBox("value_spinner"),
                QSlider("value_slider", HORIZONTAL)
            ]
        )
    )
)