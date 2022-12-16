extends Node2D
class_name PlacingBase

var item: Sprite

func _ready():
    place()

func place():
    print_debug("unoverridden place!", self)
    item.show()
    queue_free()
