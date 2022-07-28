extends Node2D
class_name FieldBlockInputs

signal hovered(which)
signal un_hovered(which)
signal pressed(which)
#signal un_pressed(which)
signal timeout(which)

var _is_dragging_over_field := false
var _enabled := false
var _timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    assert($FieldBlockCollisionArea.connect("mouse_entered", self, "_on_mouse_entered") == 0)
    assert($FieldBlockCollisionArea.connect("mouse_exited", self, "_on_mouse_exited") == 0)
    assert($FieldBlockCollisionArea.connect("input_event", self, "_on_input_event") == 0)
    assert(_timer.connect("timeout", self, "_on_timeout") == 0)
    add_child(_timer)

func start(time: float):
    _timer.start(time)

func resume():
    _timer.start()

func _on_timeout():
    print("timeout!")
    _timer.stop()
    emit_signal("timeout", self)

func _on_input_event(_viewport, event, _shape_idx):
    # mouse clicks on same block
    if(event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and _enabled):
        super_highlight()
        emit_signal("pressed",self)

func _input(event):
    # mouse clicks next to block
    if(event is InputEventMouseButton and event.button_index == BUTTON_LEFT and _enabled):
        if event.pressed:
            _is_dragging_over_field = true
        else:
            _is_dragging_over_field = false

func _on_mouse_entered():
    if not _enabled:
        return

    if _is_dragging_over_field:
        super_highlight()
        emit_signal("pressed", self)
    else:
        highlight()
        emit_signal("hovered", self)

func _on_mouse_exited():
    if not _enabled:
        return

    un_highlight()
    emit_signal("un_hovered", self)
    if not _timer.is_stopped():
        _timer.stop()
        print("force stopped")

func disable():
    _enabled = false
    _timer.stop()
    modulate = Color("#666")

func enable():
    un_highlight()
    _enabled = true

func highlight():
    modulate = Color("#cfc")

func un_highlight():
    modulate = Color("#fff")

func super_highlight():
    modulate = Color("#6f6")