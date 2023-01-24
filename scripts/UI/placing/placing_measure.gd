extends PlacingBase

func place():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    $Shovel/AnimationPlayer.play("dig")
    yield(get_tree().create_timer(time), "timeout")

    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    Input.warp_mouse_position(get_global_position())

    #apply the measure to the block
    item.show()
    emit_signal("placed")
    queue_free()
