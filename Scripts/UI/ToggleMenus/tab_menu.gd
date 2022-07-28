extends CanvasItem
class_name TabMenu

export(NodePath) var toggle_menu_path

onready var toggle_menu = get_node(toggle_menu_path) if toggle_menu_path else null

func _on_un_select():
    print("unselected ", self.name)
    hide()
    if toggle_menu:
        toggle_menu.deselect()
