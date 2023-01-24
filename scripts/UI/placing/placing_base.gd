extends Node2D
class_name PlacingBase

signal placed
var item: Sprite
var time: float

func _ready():
    place()

func place():
    print_debug("unoverridden place!", self)
    item.show()
    yield(get_tree().create_timer(.1),"timeout")
    emit_signal("placed")
    queue_free()
