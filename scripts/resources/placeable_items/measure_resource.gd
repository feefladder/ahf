extends PlaceableResource
class_name StructuralMeasureResource

export(float) var time_required = 1.0
export(float) var erosion_reduction
export(float) var fertility_increase
export(float) var salinity_effect
export(PackedScene) var scene

var field: FieldResource
var dirty := true setget ,_is_dirty

func get_min_number():
    return field.size_x

func _is_dirty():
    # so we are happy if we have full rows of terraces.
    return false #blocks_placed.size() % field.size_x != 0
