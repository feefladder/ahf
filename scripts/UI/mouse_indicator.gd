extends Node2D

export(Dictionary) var mouse_modes
export(Dictionary) var unanimated_mouse_modes = {
#    Enums.States.STATE_IDLE : null,
#    Enums.States.STATE_PLANTING_CROPS : preload("res://assets/UI/mouse_icons/seedling_icon.png"),
#    Enums.States.STATE_REMOVING_CROPS : preload("res://assets/UI/mouse_icons/shovel_icon.png"),
#    Enums.States.STATE_APPLYING_MEASURES : preload("res://assets/UI/mouse_icons/shovel_icon.png"),
#    Enums.States.STATE_MAKING_IRRIGATION : preload("res://assets/field/Measures/irrigation_horizontal.png")
}

var _visual: Sprite

func _process(_delta):
    position = get_global_mouse_position()

func _set_mouse_cursor_animated(to_what: PackedScene):
    _remove_visual()
    _visual = to_what.instance()
    add_child(_visual)
    _visual.show()
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _set_mouse_cursor(to_what):
    print("setting mouse cursor to", to_what)
    _reset_mouse_cursor()
    if to_what in unanimated_mouse_modes:
        Input.set_custom_mouse_cursor(unanimated_mouse_modes[to_what])

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


func _on_StateController_state_changed(to_what, item):
    if to_what in unanimated_mouse_modes:
        _set_mouse_cursor(to_what)
    else:
        print("setting to image!")
        _set_mouse_cursor_image(item.image)


func _on_MeasuresMenu_started_working(type):
    print("random")
    _set_mouse_cursor([type])


func _on_StateController_started_work(measure):
    print("stuff")
    if measure in mouse_modes:
        _set_mouse_cursor_animated(mouse_modes[measure])
