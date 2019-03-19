# Collection of functions which are for simplifying construction of composite GUI elements.
# By composite we mean UI components which don't exist as classes in Qt, but reusable components
# made from a collection of other widgets and layouts.
# These prefab components thus do not exist in Qt .ui files. So you can only use them in one direction.
export Section, Tab, DoubleEdit

"""
    Section(name, label, items...) -> VBoxLayout
A logical section in your GUI, consisting of a title and with a few UI components
indented below the title. The Section has some spacing to the next section.
"""
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

"""
    Tab(tab_name, filename) -> QWidget
Loads a .ui or .jl file named `filename`. Extracts root widget and attach a
tab title attribute to this widget so the returned widget can be used in a
tab widget.
"""
function Tab(tabname::AbstractString, filename::AbstractString)
    w = load_root_widget(filename)
    w.attributes.items[:title] = tabname
    w
end

"""
    DoubleEdit(name)
Use this wherever you want to use a text edit control for floating point numbers.
Under the hood this is a spinner with removed up and down buttons.
"""
function DoubleEdit(name::AbstractString)
    QDoubleSpinBox(
        name          = name,
        alignment     = Alignment[RIGHT, TRAILING, VCENTER],
        buttonSymbols = NO_BUTTONS
    )
end

function DoubleEdit(name::AbstractString, min::Real, value::Real, max::Real)
    QDoubleSpinBox(
        name          = name,
        alignment     = Alignment[RIGHT, TRAILING, VCENTER],
        buttonSymbols = NO_BUTTONS,
        minimum       = min,
        value         = value,
        maximum       = max
    )
end
