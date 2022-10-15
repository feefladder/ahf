extends PlaceableResource
class_name MeasureResource

export(float) var time_required = 1.0
export(float) var erosion_reduction
export(float) var fertility_increase
export(float) var salinity_effect
export(PackedScene) var placing_scene
export(PackedScene) var scene

var field: FieldResource
var dirty := true setget ,_is_dirty

func get_min_number():
    return field.size_x

#this is specific to terraces
func should_enable(block): #block is a fieldblock
    if block in blocks_placed:
        return false

    if blocks_placed.size() == 0:
        # empty field: enable only the bottom row
        return block.y == 0
    elif blocks_placed.size() % field.size_x != 0:
        # incomplete row: only enable the same row
        return block.y == blocks_placed[-1].y
    else:
        # completed row: enable rows above #(or below)
        for placed_block in blocks_placed:
            if placed_block.y + 1 == block.y: #or placed_block.y -1 == block.y
                return true
        return false

func _is_dirty():
    # so we are happy if we have full rows of terraces.
    return blocks_placed.size() % field.size_x != 0
