using QtUIParser

Ui(widget(
    class = "QWidget",
    name = "ButtonForm",
    geometry = Rect(0, 0, 180, 150),
    windowTitle = "Choose Colors",
    layout = BoxLayout(
        name = "top_vlayout",
        orientation = VERTICAL,
        items = [
            CheckBox("red_checkbox", "red"),
            CheckBox("green_checkbox", "green"),
            Spacer("vertical_spacer", VERTICAL, Size(20, 40))
            BoxLayout(
                name = "bottom_hlayout",
                orientation = HORIZONTAL,
                items = [
                    PushButton("ok_button", "Ok"),
                    PushButton("ok_button", "Cancel")
                ]
            )
        ]
    )
))

# Ui begin
#     Widget begin
#         class = "QWidget"
#         name = "ButtonForm"
#         geometry = Rect begin
#             x = 0
#             y = 0
#             width  = 180
#             height = 150
#         end
#         windowTitle = "Choose Colors",
#         layout = BoxLayout begin
#             name = "top_vlayout"
#             orientation = VERTICAL
#             items = [
#                 red_checkbox   = CheckBox("red"),
#                 green_checkbox = CheckBox(green"),
#                 Spacer("vertical_spacer", VERTICAL, Size(20, 40))
#                 BoxLayout(
#                     name = "bottom_hlayout",
#                     orientation = HORIZONTAL,
#                     items = [
#                         PushButton("ok_button", "Ok"),
#                         PushButton("ok_button", "Cancel")
#                     ]
#                 )
#             ]
#         end
#     end
# end
