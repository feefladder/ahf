extends Control
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
	# _set_pos()

func _process(_delta):
	if visible and follow_mouse:
		_set_pos()

func _on_object_hovered() -> void:
	self.rect_size = Vector2(0,0)
	# $Text.rect_size = Vector2(0,0)
	_set_text()
	_timer.start(delay)


func _on_object_un_hovered() -> void:
	_timer.stop()
	hide()

func _set_pos() -> void:
	print_debug("poepoa")
	var raw_position = _get_screen_pos()
	if raw_position.x > get_viewport().size.x/2:
		self.rect_position = -Vector2(rect_size.x,0)
	else:
		self.rect_position = Vector2(_current_node.rect_size.x,0)
	# print_debug(raw_position)
	#  = raw_position

func _set_text() -> void:
	get_node_or_null("Text").text = _current_node.tooltip_text

func _get_screen_pos() -> Vector2:
	if follow_mouse:
		return get_viewport().get_mouse_position()

	if _current_node is Node2D:
		return _current_node.get_global_transform_with_canvas()
	elif _current_node is Control:
		return _current_node.rect_global_position
	return Vector2()

func _on_custom_show() -> void:
	_timer.stop()
	show()
	_set_pos()
