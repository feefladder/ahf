extends CanvasItem
class_name TabMenu

signal activated(who)
signal deactivated(who)

export(NodePath) var toggle_menu_path

onready var toggle_menu = get_node(toggle_menu_path) if toggle_menu_path else null

func activate():
    show()
    emit_signal("activated", self)

func deactivate():
    hide()
    if toggle_menu:
        toggle_menu.deselect()
    emit_signal("deactivated", self)

func field_clicked(a_block):
    print("wajow, ik ben geactiveerd!", a_block)
