Ui(
    class   = "traj_logs_tab_",
    version = "4.0",
    root = QWidget(
        name     = "traj_logs_tab_",
        class    = :QWidget,
        geometry = Rect(0, 0, 587, 478),
        layout = GridLayout(
            name = "trajlogs_gridlayout",
            items = [
                GridItem(0, 0,
                    QLabel("logrun_label_", "logrun:")),
                GridItem(6, 2,
                    QRadioButton("uncertainty_log_radio_", "Uncertainity log:")),
                GridItem(0, 1, 4,
                    QComboBox("logrun_combo_")),
                GridItem(1, 3, 2,
                    QComboBox("zonelog_combo_")),
                GridItem(2, 2,
                    QLabel(
                        name      = "wells_with_log_label_",
                        text      = "wells with log:",
                        alignment = Alignment[RIGHT, TRAILING, VCENTER]
                    )),
                GridItem(1, 1, 2,
                    QLabel(
                        name      = "zonelog_label_",
                        text      = "condition zones on zonelog:",
                        alignment = Alignment[LEADING, LEFT, VCENTER]
                    )),
                GridItem(4, 1, 3,
                    QCheckBox("vertical_shift_checkbox_", "Allow vertical shifts")),
                GridItem(2, 3,
                    QWidget("wells_with_log_list_", :QListWidget)),
                GridItem(6, 3,
                    QComboBox("uncertainty_log_combo_")),
                GridItem(5, 2,
                    QRadioButton("sd_range_uncertainty_radio_", "Standard deviation range of uncertainty:")),
                GridItem(5, 3,
                    QWidget(
                        name          = "sd_range_uncertainty_spinner_",
                        class         = :QDoubleSpinBox,
                        alignment     = Alignment[RIGHT, TRAILING, VCENTER],
                        buttonSymbols = NO_BUTTONS,
                        maximum       = 1000.0,
                        value         = 100.0
                    )),
                GridItem(7, 3,
                    QWidget("wells_with_uncert_log_list_", :QListWidget)),
                GridItem(7, 2,
                    QLabel(
                        name      = "wells_with_uncert_log_label_",
                        text      = "wells with log:",
                        alignment = Alignment[RIGHT, TRAILING, VCENTER]
                    ))
            ]
        )
    )
)
