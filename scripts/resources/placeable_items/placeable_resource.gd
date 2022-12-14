extends BuyResource
class_name PlaceableResource

export(PackedScene) var placing_scene = load("res://scenes/placing/placing_immediate.tscn")
export(Vector2) var offset setget ,_get_offset
export(Vector2) var scale := Vector2(1,1) setget ,_get_scale
export(float) var time := 5.0

func _get_offset() -> Vector2:
    return offset

func _get_scale() -> Vector2:
    return scale

func should_enable(_block: Node) -> bool:
    return true
