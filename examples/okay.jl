using QtUIParser

ui = Ui(Widget(
    class  = "QWidget",
    name   = "OkayForm",
    geometry = Rect(0, 0, 156, 156),
    windowTitle = "Form",
    layout = BoxLayout(
        name  = "verticalLayout",
        orientation = VERTICAL,
        items = [
            PushButton(
                name = "okay_button",
                text = "okay!"
            )
        ]
    )
))

xml(ui)
