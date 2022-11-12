extends CanvasItem
class_name ToggleButton

export(StreamTexture) var icon
export(String) var title

signal pressed(which)
signal hovered(bwhich)
signal un_hovered(which)

# Called when the node enters the scene tree for the first time.
func _ready():
    if connect("mouse_entered",self,"_on_mouse_entered"):
        print_debug("connect failed!")
    if connect("mouse_exited",self,"_on_mouse_exited"):
        print_debug("connect failed!")
    $Icon.texture = icon
    $Title.text = tr(title)

func _gui_input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            emit_signal("pressed", self)

func _on_mouse_entered():
    emit_signal("hovered", self)

func _on_mouse_exited():
    emit_signal("un_hovered", self)
