extends PlaceableResource
class_name CropResource

export(float) var sell_price #currency/ton
export(float) var max_yield  #ton/ha
export(float) var f_wlimited_yield #-
export(float) var f_actual_yield

func should_enable(block):
    return not block.has_crop
