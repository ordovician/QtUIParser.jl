using QtUIParser

ui = Ui(Widget(
    class  = "QWidget",
    name   = "EmptyForms",
    geometry = Rect(0, 0, 120, 120),
    windowTitle = "Form"
))

xml(ui)
