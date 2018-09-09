using QtUIParser

ui = Ui(Widget(
    class  = "QWidget",
    name   = "DepthConvertPanel",
    geometry = Rect(0, 0, 505, 615),
    windowTitle = "Depth Convert Seismic",
    layout = VBoxLayout(
        name = "top",
        items = [
            GroupBox(
                name = "general",
                layout = HBoxLayout(
                    name = "general_layout",
                    items = [
                        GridLayout(
                            name = "output_layout",
                            items = [
                                GridItem(0, 0, Label("name_label", "Output name:")),
                                GridItem(0, 1, LineEdit("name_edit", "Output name:"))
                            ]
                        ),
                        
                        VBoxLayout(
                            name = "type_layout",
                            items = [
                                RadioButton("realized", "Realized"),
                                RadioButton("preview", "Preview"),
                                Spacer("type_spacer", VERTICAL, Size(10, 20))
                            ]
                        )
                    ]
                )
            ),
            GridLayout(
                name = "cropping_layout",
                items = [
                    GridItem(0, 0, CheckBox("depth_crop", "Cropping in depth")),
                    GridItem(2, 0, Label(   "range_label","Sample range:")),
                    GridItem(1, 1, Label(   "min_label", "Min")),                    
                    GridItem(2, 1, LineEdit("min_edit",  "0.0")),
                    GridItem(3, 1, Slider("min_slider")),
                    GridItem(1, 2, Label(   "max_label", "Max")),
                    GridItem(2, 2, LineEdit("max_edit",  "0.0")),
                    GridItem(3, 2, Slider("max_slider"))
                ]
            )
        ]
    )    
))