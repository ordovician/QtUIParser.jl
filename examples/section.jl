"A section with a single UI element indented below a label"
function Section(name::AbstractString, label::AbstractString, items::Item...)
    VBoxLayout(
        name = "$(name)_layout_",
        items = [
            QLabel("$(name)_label_", label),
            HBoxLayout(
                name = "hbox_$(name)_layout_",
                items = [
                    Spacer(
                        name        = "$(name)_spacer_",
                        orientation = HORIZONTAL,
                        sizeHint    = Size(18, 20),
                        sizeType    = FIXED
                    ),
                    items...
                ]
            ),
            Spacer(
                name        = "$(name)_section_spacer_",
                orientation = VERTICAL,
                sizeHint    = Size(20, 18),
                sizeType    = FIXED
            )
        ]
    )
end
