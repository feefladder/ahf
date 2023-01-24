extends Node2D
class_name FieldBlockInputs

#signal hovered(which)
#signal un_hovered(which)
signal pressed(which)
signal unpressed(which)

var _mouse_down := false
var _mouse_over := false
var _enabled := true

const M_COLOR_HIGHLIGHT := Color("#cfc")
const M_COLOR_UN_HIGHLIGHT := Color("#fff")
const M_COLOR_SUPER_HIGHLIGHT := Color("#6f6")
const M_COLOR_DISABLE := Color("#666")

# Called when the node enters the scene tree for the first time.
func _ready():
    # warning-ignore:return_value_discarded
    connect("mouse_entered", self, "_on_mouse_entered")
    # warning-ignore:return_value_discarded
    connect("mouse_exited", self, "_on_mouse_exited")
    # warning-ignore:return_value_discarded
    connect("input_event", self, "_on_input_event")

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
            un_highlight()
            emit_signal("unpressed", self)

func _input(event):
    # mouse clicks next to block
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
        if event.pressed:
            _mouse_down = true
        else:
            _mouse_down = false
        if _mouse_over and _enabled:
            super_highlight()
            emit_signal("pressed", self)

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
    if not _enabled:
        return
    _enabled = false
    tween_modulate(modulate, M_COLOR_DISABLE)

func enable():
    if _enabled:
        return
    un_highlight()
    _enabled = true

func highlight():
    tween_modulate(modulate, M_COLOR_HIGHLIGHT)

func un_highlight():
    tween_modulate(modulate, M_COLOR_UN_HIGHLIGHT)

func super_highlight():
    tween_modulate(modulate, M_COLOR_SUPER_HIGHLIGHT)

func tween_modulate(start: Color, end: Color, time=0.5):
    var tween = Tween.new()
    add_child(tween)
    tween.interpolate_property(
        self,
        "modulate",
        start,
        end,
        time,
        Tween.TRANS_CUBIC,
        Tween.EASE_OUT
    )
    tween.start()
    tween.connect("tween_all_completed",tween,"queue_free")

