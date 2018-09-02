# Qt UI Parser
A Parser and generator for the `.ui` XML files used by [Qt Designer and Creator][creator]. This is a file format used to store user interfaces designed using the Qt Designer tool, and which can be proccessed by the [uic][uic] command.

## Purpose and Motivation
Managing layouts in [Qt Designer][creator] is difficult. The borders on the layout are 1 pixel wide and you have to pay a lot of attention to hit them. It is easy to accidentally pull a widget out of a layout and ruin it. A complex layout can be exceedingly difficult to change without breaking then, and then struggle with putting it back together.

I tried to overcome these problems by editing the `.ui` file XML format directly. However that proved difficult as the format was clearly not designed for manual editing.

That is the purpose of this package. To provide an assortment of tools to manipulate the `.ui` files with a more friendly interface.

## Status
This is work in progress. Generating a `.ui` file mostly works, but the parsing of the `.ui` file and turning it into higher level objects is broken at the moment.

# Installation
This has been made for the new package manager in Julia 0.7. You hit the `]` key in the Julia REPL (command line interface) and write.

    pkg> add https://github.com/ordovician/QtUIParser.jl

This is because QtUIParser is presently not a registered package.


[uic]: http://doc.qt.io/archives/qt-4.8/uic.html
[qt]: https://www.qt.io
[creator]: https://www.qt.io/qt-features-libraries-apis-tools-and-ide/