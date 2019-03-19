Ui(
    class   = "wellpicks_tab_",
    version = "4.0",
    root = QWidget(
        name     = "wellpicks_tab_",
        class    = :QWidget,
        attributes = Attributes(
                title = "Wellpicks"
            ),
        geometry = Rect(0, 0, 539, 454),
        layout = VBoxLayout(
            name = "top_wellpick_layout_",
            items = [
                HBoxLayout(
                    name = "pick_selection_layout_",
                    items = [
                        QLabel("wellpickset_label_", "Wellpick set:"),
                        QComboBox("wellpick_set_combo_"),
                        QLabel(
                            name      = "pick_display_label_",
                            text      = "display:",
                            alignment = Alignment[RIGHT, TRAILING, VCENTER]
                        ),
                        QRadioButton("individual_radio_", "individual picks"),
                        QRadioButton("summary_radio_", "summary")
                    ]
                ),
                QWidget("wellpicks_table_", :QTableWidget),
                GridLayout(
                    name = "wellpick_uncertainty_layout_",
                    items = [
                        GridItem(0, 0,
                            QLabel("uncertainty_from_label_", "get uncertainty for each wellpick from:")),
                        GridItem(0, 1,
                            QRadioButton("uncert_attr_table_radio", "uncertainty attribute in table")),
                        GridItem(1, 1,
                            QRadioButton("uncert_const_radio", "constant"))
                    ]
                )
            ]
        )
    )
)
