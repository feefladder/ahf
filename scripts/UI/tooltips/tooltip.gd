extends CanvasItem
class_name Tooltip

export(float, 0, 10, 0.05) var delay = 0.5
export(Vector2) var offset = Vector2(0,0)
export(bool) var follow_mouse = false
export(bool) var give_me_a_better_name = false


var _timer: Timer
var _current_node: Node

onready var extents = self.rect_size

# Called when the node enters the scene tree for the first time.
func _ready():
    _current_node = get_parent()
    # warning-ignore:return_value_discarded
    _current_node.connect("mouse_entered", self, "_on_object_hovered")
    # warning-ignore:return_value_discarded
    _current_node.connect("mouse_exited", self, "_on_object_un_hovered")
    hide()
    #initialize timer
    _timer = Timer.new()
    # warning-ignore:return_value_discarded
    _timer.connect("timeout",self,"_on_custom_show")
    add_child(_timer)
    _set_text()
    # _set_position()

func _process(_delta):
    if visible and follow_mouse:
        _set_position()

func _on_object_hovered() -> void:
    print_debug("object ", _current_node.tooltip_text)
    self.rect_size = Vector2(0,0)
    $Text.rect_size = Vector2(0,0)
    _set_text()
    _set_position()
    _timer.start(delay)


func _on_object_un_hovered() -> void:
    _timer.stop()
    hide()

func _set_position() -> void:
    var raw_position = _get_screen_pos()
    if raw_position.x > get_viewport().size.x/2:
        self.rect_position = -Vector2($Text.rect_size.x,0)
    else:
        self.rect_position = Vector2(_current_node.rect_size.x,0)
    # print_debug(raw_position)
    #  = raw_position

func _set_text() -> void:
    $Text.text = _current_node.tooltip_text

func _get_screen_pos() -> Vector2:
    if follow_mouse:
        return get_viewport().get_mouse_position()

    if _current_node is Node2D:
        return _current_node.get_global_transform_with_canvas()
    elif _current_node is Control:
        return _current_node.rect_global_position
    return Vector2()

func _on_custom_show() -> void:
    print_debug("show ", _current_node.tooltip_text)
    _timer.stop()
    show()
