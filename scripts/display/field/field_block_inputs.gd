extends Node2D
class_name FieldBlockInputs

#signal hovered(which)
#signal un_hovered(which)
signal pressed(which)
signal unpressed(which)
signal timeout(which)

var _mouse_down := false
var _mouse_over := false
var _enabled := true
var _timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    # warning-ignore:return_value_discarded
    connect("mouse_entered", self, "_on_mouse_entered")
    # warning-ignore:return_value_discarded
    connect("mouse_exited", self, "_on_mouse_exited")
    # warning-ignore:return_value_discarded
    connect("input_event", self, "_on_input_event")
    # warning-ignore:return_value_discarded
    _timer.connect("timeout", self, "_on_timeout")
    add_child(_timer)

func start(time: float):
    _timer.start(time)

func resume():
    _timer.set_paused(false)

func pause():
    _timer.set_paused(true)

func _on_timeout():
    _timer.stop()
    emit_signal("timeout", self)

func _on_input_event(_viewport, event, _shape_idx):
    # mouse clicks on same block
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
        _mouse_down = event.pressed

        if not _enabled:
            return

        if _mouse_down:
            super_highlight()
            emit_signal("pressed",self)
        else:
            emit_signal("unpressed", self)
            un_highlight()
   

func _input(event):
    # mouse clicks next to block
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
        if event.pressed:
            _mouse_down = true
        else:
            _mouse_down = false
        if _mouse_over and _enabled:
            emit_signal("pressed", self)
            highlight()

func _on_mouse_entered():
    _mouse_over = true
    if not _enabled:
        return
    if _mouse_down:
        super_highlight()
        emit_signal("pressed", self)
    else:
        highlight()

func _on_mouse_exited():
    _mouse_over = false
    if not _enabled:
        return

    un_highlight()
    if _mouse_down:
        emit_signal("unpressed", self)

func disable():
    _enabled = false
    _timer.stop()
    modulate = Color("#666")

func enable():
    if not _enabled:
        un_highlight()
        _enabled = true

func highlight():
    modulate = Color("#cfc")

func un_highlight():
    modulate = Color("#fff")

func super_highlight():
    modulate = Color("#6f6")
