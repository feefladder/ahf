extends CanvasItem
class_name Tooltip

export(float, 0, 10, 0.05) var delay = 0.3
export(Vector2) var offset = Vector2(0,0)
export(bool) var follow_mouse = false
export(bool) var give_me_a_better_name = true


var _timer: Timer
var _current_node: Node

onready var extents = self.rect_size

# Called when the node enters the scene tree for the first time.
func _ready():
    hide()
    #initialize timer
    _timer = Timer.new()
    assert(_timer.connect("timeout",self,"_on_custom_show") == 0)
    add_child(_timer)

func _process(_delta):
    if visible and follow_mouse:
        _set_position()

func _on_object_hovered(which) -> void:
    _current_node = which
    self.rect_size = Vector2(0,0)
    $TextContainer.rect_size = Vector2(0,0)
    _set_text()
    _set_position()
    _timer.start(delay)

func _on_object_un_hovered(_which) -> void:
    _timer.stop()
    hide()

func _set_position() -> void:
    var raw_position = _get_screen_pos()
    if give_me_a_better_name:
        raw_position -= Vector2($TextContainer.rect_size.x,0)
    else:
        raw_position += Vector2(_current_node.rect_size.x,0)
    self.rect_position = raw_position

func _set_text() -> void:
    $TextContainer/Text.text = _current_node.get_node("Title").text

func _get_screen_pos() -> Vector2:
    if follow_mouse:
        return get_viewport().get_mouse_position()

    if _current_node is Node2D:
        return _current_node.get_global_transform_with_canvas()
    elif _current_node is Control:
        return _current_node.rect_global_position
 
    return Vector2()

func _on_custom_show() -> void:
    show()


func _on_TextContainer_resized():
    _set_position()
