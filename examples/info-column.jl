Ui(
    class   = "info_column_",
    version = "4.0",
    root = QWidget(
        name     = "info_column_",
        class    = :QWidget,
        geometry = Rect(0, 0, 291, 292),
        layout = VBoxLayout(
            name = "info_column_layout_",
            items = [
                QLabel(
                    name = "log_pick_conflicts_title_",
                    text = "Log and Wellpick Data Conflicts",
                    font = Font(12, 75, FontStyle[BOLD, ITALIC])
                ),
                QWidget("conflicts_table_", :QTableWidget),
                QLabel(
                    name       = "log_pick_conflicts_help_",
                    text       = "Shows horizons and well where there is a conflict between uncertainty data provided by wellpicks, trajectories and logs.",
                    font       = Font(9, nothing, FontStyle[]),
                    textFormat = PLAIN_TEXT,
                    wordWrap   = true,
                    indent     = 10
                )
            ]
        )
    )
)
