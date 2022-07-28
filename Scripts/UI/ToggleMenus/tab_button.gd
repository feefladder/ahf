extends ToggleButton
class_name TabButton

export(NodePath) var my_tab

func _on_button_pressed():
    if(my_tab):
        get_node(my_tab).show()

func un_select():
    if(my_tab):
        get_node(my_tab)._on_un_select()
