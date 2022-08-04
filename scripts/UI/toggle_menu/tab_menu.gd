extends CanvasItem
class_name TabMenu

signal activated(who)
signal deactivated(who)

export(NodePath) var toggle_menu_path

onready var toggle_menu = get_node_or_null(toggle_menu_path)

func activate():
    show()
    emit_signal("activated", self)

func deactivate():
    hide()
    if toggle_menu:
        toggle_menu.deselect()
    emit_signal("deactivated", self)
