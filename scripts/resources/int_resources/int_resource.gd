extends BuyResource
class_name IntResource

export(int) var current_number = 0
export(int) var max_number = 5 setget _set_max, _get_max

func _get_max() -> int:
    return max_number

func _set_max(new_max: int) -> void:
    max_number = new_max
