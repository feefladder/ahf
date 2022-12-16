extends PlacingBase

var time_required: float = 0.1

func place():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    $Shovel/AnimationPlayer.play("dig")
    yield(get_tree().create_timer(time_required), "timeout")

    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    Input.warp_mouse_position(get_global_position())

    #apply the measure to the block
    item.show()
    emit_signal("placed")
    queue_free()
