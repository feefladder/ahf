extends PlaceableResource
class_name StructuralMeasureResource

export(float) var time_required = 0.1
export(float) var erosion_reduction
export(float) var fertility_increase
export(float) var salinity_effect
export(PackedScene) var scene

func get_min_number():
    return 3#field.size_x

func should_enable(block):
    # should enable if:
    # - there are none applied yet and we are the bottom row
    # - there are full rows and we are one above the previous row
    # - there is an incomplete row and we are part of that
    # overruled by:
    # - there is already a structural measure -> disable
    if not block.is_empty("structural_measure"):
        return false
    var blocks_placed: Array = block.get_all_with("structural_measure", resource_name)
    if blocks_placed.size() == 0:
        return block.y == 0
    elif blocks_placed.size() % 3 != 0:
        return block.y == blocks_placed[-1]["y"]
    else:
        return block.y == blocks_placed[-1]["y"] + 1

