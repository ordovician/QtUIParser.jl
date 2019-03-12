Ui(
    class   = "HUMPanel",
    version = "4.0",
    root = QWidget(
        name        = "HUMPanel",
        class       = :QWidget,
        geometry    = Rect(0, 0, 463, 556),
        windowTitle = "Form",
        layout = VBoxLayout(
            name = "verticalLayout_9",
            items = [
                QWidget(
                    name         = "main_tab_widget_",
                    class        = :QTabWidget,
                    currentIndex = 1,
                    children = [
                        QWidget(
                            name       = "general_tab_",
                            class      = :QWidget,
                            attributes = Attributes(
                                    title = "General"
                                ),
                            layout = VBoxLayout(
                                name = "verticalLayout_6",
                                items = [
                                    VBoxLayout(
                                        name = "verticalLayout",
                                        items = [
                                            QLabel("horizon_model_label_", "Input horizon model:"),
                                            HBoxLayout(
                                                name = "horizontalLayout",
                                                items = [
                                                    Spacer(
                                                        name        = "horizontalSpacer",
                                                        orientation = HORIZONTAL,
                                                        sizeHint    = Size(18, 20),
                                                        sizeType    = FIXED
                                                    ),
                                                    QWidget("input_hmodel_", :QtCompComboBox)
                                                ]
                                            ),
                                            Spacer(
                                                name        = "verticalSpacer",
                                                orientation = VERTICAL,
                                                sizeHint    = Size(20, 18),
                                                sizeType    = FIXED
                                            )
                                        ]
                                    ),
                                    VBoxLayout(
                                        name = "verticalLayout_3",
                                        items = [
                                            QLabel("mode_label_", "For each input horizon create:"),
                                            HBoxLayout(
                                                name = "horizontalLayout_2",
                                                items = [
                                                    Spacer(
                                                        name        = "horizontalSpacer_2",
                                                        orientation = HORIZONTAL,
                                                        sizeHint    = Size(18, 20),
                                                        sizeType    = FIXED
                                                    ),
                                                    VBoxLayout(
                                                        name = "verticalLayout_2",
                                                        items = [
                                                            QRadioButton("prediction_radio_", "one unique surface using prediction"),
                                                            QRadioButton("simulation_radio_", "one realization using stochastic simulation")
                                                        ]
                                                    )
                                                ]
                                            ),
                                            Spacer(
                                                name        = "verticalSpacer_2",
                                                orientation = VERTICAL,
                                                sizeHint    = Size(20, 38),
                                                sizeType    = FIXED
                                            )
                                        ]
                                    ),
                                    VBoxLayout(
                                        name = "verticalLayout_5",
                                        items = [
                                            QLabel("output_structural_model_label_", "Output structural model:"),
                                            HBoxLayout(
                                                name = "horizontalLayout_4",
                                                items = [
                                                    Spacer(
                                                        name        = "horizontalSpacer_4",
                                                        orientation = HORIZONTAL,
                                                        sizeHint    = Size(18, 20),
                                                        sizeType    = FIXED
                                                    ),
                                                    QWidget(
                                                        name     = "output_smodel_",
                                                        class    = :QtCompComboBox,
                                                        editable = true
                                                    )
                                                ]
                                            )
                                        ]
                                    ),
                                    Spacer("verticalSpacer_4", VERTICAL, Size(20, 40))
                                ]
                            )
                        ),
                        QWidget(
                            name       = "well_data_tab_",
                            class      = :QWidget,
                            attributes = Attributes(
                                    title = "Well Data"
                                ),
                            layout = VBoxLayout(
                                name = "verticalLayout_8",
                                items = [
                                    VBoxLayout(
                                        name = "verticalLayout_7",
                                        items = [
                                            QLabel("wells_label_", "Get wellpicks and well trajectories from:"),
                                            HBoxLayout(
                                                name = "horizontalLayout_5",
                                                items = [
                                                    Spacer(
                                                        name        = "horizontalSpacer_5",
                                                        orientation = HORIZONTAL,
                                                        sizeHint    = Size(18, 20),
                                                        sizeType    = FIXED
                                                    ),
                                                    QWidget("wells_selector_combo_", :WObjectsSelector)
                                                ]
                                            )
                                        ]
                                    ),
                                    Spacer(
                                        name        = "verticalSpacer_6",
                                        orientation = VERTICAL,
                                        sizeHint    = Size(20, 10),
                                        sizeType    = FIXED
                                    ),
                                    QGroupBox(
                                        name      = "wellpicks_group_",
                                        title     = "condition using wellpicks",
                                        checkable = true,
                                        layout = GridLayout(
                                            name = "gridLayout",
                                            items = [
                                                GridItem(0, 0,
                                                    QLabel("wellpickset_label_", "Wellpick set:")),
                                                GridItem(0, 1,
                                                    QComboBox("wellpick_set_combo_")),
                                                GridItem(1, 0,
                                                    QLabel("uncertainty_label_", "For uncertainty use:")),
                                                GridItem(1, 1,
                                                    QRadioButton("constant_radio_", "constant")),
                                                GridItem(2, 1,
                                                    QRadioButton("attribute_radio_", "depth uncertainty attribute"))
                                            ]
                                        )
                                    ),
                                    Spacer(
                                        name        = "verticalSpacer_7",
                                        orientation = VERTICAL,
                                        sizeHint    = Size(20, 10),
                                        sizeType    = FIXED
                                    ),
                                    QGroupBox(
                                        name      = "wellpath_group_",
                                        title     = "condition using wellpath data",
                                        checkable = true,
                                        layout = GridLayout(
                                            name = "gridLayout_2",
                                            items = [
                                                GridItem(1, 1, 2,
                                                    QLabel("zonelog_label_", "condition zones on zonelog:")),
                                                GridItem(5, 3,
                                                    QWidget(
                                                        name          = "sd_range_uncertainty_spinner_",
                                                        class         = :QDoubleSpinBox,
                                                        alignment     = Alignment[RIGHT, TRAILING, VCENTER],
                                                        buttonSymbols = NO_BUTTONS,
                                                        maximum       = 1000.0,
                                                        value         = 100.0
                                                    )),
                                                GridItem(1, 3, 2,
                                                    QComboBox("zonelog_combo_")),
                                                GridItem(2, 1, 3,
                                                    QCheckBox("vertical_shift_checkbox_", "Allow vertical shifts")),
                                                GridItem(4, 2, 2,
                                                    QRadioButton("sd_range_uncertainty_radio_", "Standard deviation range of uncertainty:")),
                                                GridItem(0, 0,
                                                    QLabel("logrun_label_", "logrun:")),
                                                GridItem(0, 1, 4,
                                                    QComboBox("logrun_combo_")),
                                                GridItem(3, 2,
                                                    QRadioButton("uncertainty_log_radio_", "Uncertainity log:")),
                                                GridItem(3, 3,
                                                    QComboBox("uncertainty_log_combo_"))
                                            ]
                                        )
                                    ),
                                    Spacer("verticalSpacer_5", VERTICAL, Size(20, 40))
                                ]
                            )
                        )
                    ]
                )
            ]
        )
    ),
    customwidgets = [
        CustomWidget(:WObjectsSelector, :QWidget, "panel/ui/wobjectsselector.h"),
        CustomWidget(:QtCompComboBox, :QComboBox, "uiqt/qtcompcombobox.h")
    ]
)