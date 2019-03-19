Ui(
    class   = "HorizonsTab",
    version = "4.0",
    root = QWidget(
        name  = "HorizonsTab",
        class = :QWidget,
        layout = GridLayout(
            name = "main_horizons_layout_",
            items = [
                GridItem(0, 0, 9, 5,
                    QWidget("horizons_table_", :QTableWidget)),
                    
                GridItem(0, 5,
                    QLabel("visual_filter_label_", "Visual Filter")),
                GridItem(1, 5,
                    QPushButton("depth_surface_btn_", "depth surface")),                   
                GridItem(2, 5,
                    QPushButton("reflector_btn_", "reflector")),
                    
                GridItem(6, 5,
                    QLabel("edit_attr_label_", "Edit Attributes For")),                                      
                GridItem(7, 5,
                    QPushButton("zone_thickness_btn_", "zone thickness...")),
                GridItem(8, 5,
                    QPushButton("time_interpret_btn_", "time interpretations...")),
                                                             
                GridItem(9, 1,
                    QPushButton("add_menu_btn_", "Add")),
                GridItem(9, 2,
                    QPushButton("remove_btn_", "Remove")),
                GridItem(9, 3,
                    QPushButton("reset_zone_setup_btn_", "reset zone setup..."))
            ]
        )
    )
)