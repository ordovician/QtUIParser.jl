# Qt UI Parser
A Parser and generator for the `.ui` XML files used by [Qt Designer and Creator][creator]. This is a file format used to store user interfaces designed using the Qt Designer tool, and which can be proccessed by the [uic][uic] command.

## Purpose and Motivation
Managing layouts in [Qt Designer][creator] is difficult. The borders on the layout are 1 pixel wide and you have to pay a lot of attention to hit them. It is easy to accidentally pull a widget out of a layout and ruin it. A complex layout can be exceedingly difficult to change without breaking then, and then struggle with putting it back together.

I tried to overcome these problems by editing the `.ui` file XML format directly. However that proved difficult as the format was clearly not designed for manual editing.

That is the purpose of this package. To provide an assortment of tools to manipulate the `.ui` files with a more friendly interface.

## Status
Parsing and generating `.ui` files work, with the exception of some UI components. Tabs are not well supported presently.

# Installation
This has been made for the new package manager in Julia 0.7. You hit the `]` key in the Julia REPL (command line interface) and write.

    pkg> add https://github.com/ordovician/QtUIParser.jl

This is because QtUIParser is presently not a registered package.


[uic]: http://doc.qt.io/archives/qt-4.8/uic.html
[qt]: https://www.qt.io
[creator]: https://www.qt.io/qt-features-libraries-apis-tools-and-ide/

# Usage
If you look in the example folder you can find several examples of `.ui` and `.jl` files describing different user interfaces. The `.jl` files contains GUIs described in what I am currently calling ERML format. ERML is a type of Julia domain specific language (DSL) for describing user interfaces. This is a simple ERML example in the `colors.jl` file:

    Ui(
        class   = "ColorsForm",
        version = "4.0",
        root = QWidget(
            name        = "ColorsForm",
            class       = :QWidget,
            geometry    = Rect(0, 0, 121, 73),
            windowTitle = "Form",
            layout = VBoxLayout(
                name = "top_layout",
                items = [
                    QCheckBox("red_box", "red"),
                    QCheckBox("blue_box", "blue")
                ]
            )
        )
    )

Because this is valid julia code you can run this file and get a Ui object by simply writing:

    julia> ui = include("colors.jl")

You can turn the top node in this tree or subnodes into xml which can be stored in `.ui` files:

    julia> xml(ui)
    julia> xml(ui.root)

Use the `read_ui` function to read and parse a `.ui` file and turn it into ERML format:

    julia> read_ui("colors.ui")
    Ui(
        class   = "ColorsForm",
        version = "4.0",
        root = QWidget(
            name        = "ColorsForm",
            class       = :QWidget,
            geometry    = Rect(0, 0, 121, 73),
            windowTitle = "Form",
            layout = VBoxLayout(
                name = "top_layout",
                items = [
                    QCheckBox("red_box", "red"),
                    QCheckBox("blue_box", "blue")
                ]
            )
        )
    )

## Shortcuts and Practical Usage
When working with UI files there will be common patterns of usage. I have added functions in the `tools.jl` file to support this.

### Loading .ui and .jl Files
The `load` convenience function alls you to load files regardless of whether they are `.ui` or `.jl` files.

    julia> ui = load("colors.ui")
    julia> ui = load("colors.jl")

It keeps track of which file was loaded, so in the case of `.ui` files you can load them again with

    julia> ui = load()

### Saving .ui and .jl Files
You use different functions depending on the storage format you want to use. Say you have create a user interface object and stored it in `ui` variable. You can save it in either Qt UI format or ERML format with:

    julia> save_erml_as("colors.jl", ui)
    julia> save_ui_as("colors.ui", ui)

It will remember what ui object and filepath was used so you don't have to specify them later.

    julia> save_erml()
    julia> save_ui()

Or you can specify another path:

    julia> save_erml_as("foobar.jl")
    julia> save_ui_as("foobar.ui")
