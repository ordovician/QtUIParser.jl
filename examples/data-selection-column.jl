include("section.jl")

Ui(
    class   = "DataSelectionColumn",
    version = "4.0",
    root = QWidget(
        name     = "data_selection_column_",
        class    = :QWidget,
        geometry = Rect(0, 0, 354, 355),
        layout = VBoxLayout(
            name = "data_selection_column_layout_",
            items = [
                Section("input_hmodel", "Input horizon model:",
                    QWidget("input_hmodel_combo_", :QtCompComboBox)),
                Section("algomode",  "For each input horizon create:",
                    VBoxLayout(
                        name = "algomode_radio_layout_",
                        items = [
                            QRadioButton("prediction_radio_", "one unique surface using prediction"),
                            QRadioButton("simulation_radio_", "one realization using stochastic simulation")
                        ]
                    )
                ),
                Section("kriging", "Condition surfaces using:",
                    QComboBox("kriging_combo_"), QLabel("kriging_method_label", "kriging method")),
                Spacer("middle_spacer_", VERTICAL, Size(20, 40)),
                Section("data_conditioning", "Condition surfaces using:",
                    VBoxLayout(
                        name = "well_data_checkbox_layout_",
                        items = [
                            QCheckBox("wellpicks_option_", "wellpicks"),
                            QCheckBox("traj_option_", "trajectories and logs")
                        ]
                    )
                ),
                Section("well_data", "Input well data:",
                    QWidget("wells_selector_combo_", :WObjectsSelector)),

                Section("output_smodel", "Output structural model:",
                    QWidget(
                        name     = "output_smodel_",
                        class    = :QtCompComboBox,
                        editable = true
                    )
                )
            ]
        )
    ),
    customwidgets = [
        CustomWidget(:QtCompComboBox, :QComboBox, "uiqt/qtcompcombobox.h")
    ]
)
