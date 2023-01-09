extends PlacingBase

func place():
    $AnimationPlayer.play("plant")
    yield($AnimationPlayer, "animation_finished")
    tween_item()
    queue_free()

func tween_item():
    var tween = Tween.new()
    item.add_child(tween)
    tween.interpolate_property(
            item,
            "position",
            Vector2(0.0,0.0),
            item.position,
            time,
            Tween.TRANS_CUBIC,
            Tween.EASE_OUT
    )
    tween.interpolate_property(
            item,
            "scale",
            Vector2(0.0, 0.0),
            item.scale,
            time,
            Tween.TRANS_CUBIC,
            Tween.EASE_OUT
    )
    item.scale = Vector2(0.0, 0.0)
    item.position = Vector2(0.0, 0.0)
    tween.start()
    tween.connect("tween_all_completed",tween,"queue_free")
    item.show()
