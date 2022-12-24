extends PlaceableResource
class_name CropResource

export(float) var sell_price #currency/ton
export(float) var max_yield  #ton/ha
export(float, 0,1) var f_wlimited_yield #-
export(float, 0,1) var f_actual_yield
export(float, 0.5, 10) var ec_threshold #dS/m
export(float, 0,1) var b #/(dS/m)


func _get_offset():
    return Vector2(0,-image.get_size().y/2*scale.y)

func should_enable(block) -> bool:
    if resource_name != "remove":
        return block.is_empty("crop")
    else:
        return not block.is_empty("crop")
