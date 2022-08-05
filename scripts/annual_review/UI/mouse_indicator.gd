extends Node2D
class_name MouseIndicator

export(Dictionary) var mouse_modes

signal finished

var _visual: Sprite

func _ready():
    position = get_global_mouse_position()

func play_for_time(animation_scene: PackedScene, time: float) -> void:
    var animation = animation_scene.instance()
    add_child(animation)
    set_process(false)
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    yield(get_tree().create_timer(time), "timeout")
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    Input.warp_mouse_position(position)
    emit_signal("finished")
    queue_free()

func play_non_blocking(animation: Node2D) -> void:
    add_child(animation)
    yield(animation, "animation_finished")
    emit_signal("finished")
    queue_free()

func _process(_delta):
    position = get_global_mouse_position()

func _set_mouse_cursor_animated(to_what: PackedScene):
    _remove_visual()
    _visual = to_what.instance()
    add_child(_visual)
    _visual.show()
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _set_mouse_cursor_image(image):
    _remove_visual()
    _visual = Sprite.new()
    _visual.texture = image
    var scale := 64.0/max(image.get_width(), image.get_height())
    _visual.scale = Vector2(scale,scale)
    _visual.position = Vector2(0,-32)
    _visual.z_index = 10
    add_child(_visual)
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _remove_visual():
    if _visual:
        remove_child(_visual)
        _visual.queue_free()
        _visual = null

func _reset_mouse_cursor():
    _remove_visual()
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_CropsMenu_change_mouse(to_what):
    _set_mouse_cursor_image(to_what)
