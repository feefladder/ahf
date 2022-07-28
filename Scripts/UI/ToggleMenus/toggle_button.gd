extends CanvasItem
class_name ToggleButton

export(StreamTexture) var icon
export(String) var title


signal pressed(which)
signal hovered(bwhich)
signal un_hovered(which)

# Called when the node enters the scene tree for the first time.
func _ready():
    self.connect("mouse_entered",self,"_on_mouse_entered")
    self.connect("mouse_exited",self,"_on_mouse_exited")
    $Icon.texture = icon
    $Title.text = title

func _gui_input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            emit_signal("pressed", self)
            _on_button_pressed()

func _on_button_pressed():
    pass

func un_select():
    pass

func _on_mouse_entered():
    emit_signal("hovered", self)

func _on_mouse_exited():
    emit_signal("un_hovered", self)
