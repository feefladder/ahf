extends MeasureState
# timer

var digging = load("res://scenes/mouse/digging_shovel.tscn")

var _visual: Node2D

func should_enable(field_block):
    # only enable the current block
    return field_block == fsm.current_block

func enter():
    print(digging)
    var indicator = MouseIndicator.new()
    get_tree().get_root().add_child(indicator)
    indicator.play_for_time(digging, fsm.resource.time_required)
    yield(indicator, "finished")
    print("indicator finished")
    exit()

func fieldblock_pressed(which):
    print("block pressed!")

func exit():
    fsm.apply_current_block()
    if fsm.num_placed >= fsm.field.field_resource.size_x * fsm.field.field_resource.size_y:
        fsm.completed()
    elif fsm.num_placed % fsm.field.field_resource.size_x:
        fsm.change_to("incomplete")
    else:
        fsm.change_to("completed_row")

func _remove_visual():
    if _visual:
        print("removing visual")
        remove_child(_visual)
        _visual.queue_free()
        _visual = null

func _set_mouse_cursor_animated(to_what: PackedScene):
    _remove_visual()
    _visual = to_what.instance()
    add_child(_visual)
    _visual.show()
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _set_mouse_cursor_image(image):
    _visual = Sprite.new()
    _visual.texture = image
    var scale := 64.0/max(image.get_width(), image.get_height())
    _visual.scale = Vector2(scale,scale)
    _visual.position = Vector2(0,-32)
    _visual.z_index = 10
    add_child(_visual)
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

