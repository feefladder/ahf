extends Node2D

export(float) var growth_time = 5.0

var crop: Sprite

func _ready():
    $AnimationPlayer.play("plant")
    yield($AnimationPlayer, "animation_finished")
    tween_crop()
    queue_free()

func tween_crop():
    var tween = Tween.new()
    crop.add_child(tween)
    tween.interpolate_property(
            crop,
            "position",
            Vector2(0.0,0.0),
            crop.position,
            growth_time,
            Tween.TRANS_CUBIC,
            Tween.EASE_OUT
    )
    tween.interpolate_property(
            crop,
            "scale",
            Vector2(0.0, 0.0),
            crop.scale,
            growth_time,
            Tween.TRANS_CUBIC,
            Tween.EASE_OUT
    )
    crop.scale = Vector2(0.0, 0.0)
    crop.position = Vector2(0.0, 0.0)
    tween.start()
    tween.connect("tween_all_completed",tween,"queue_free")
    crop.show()
