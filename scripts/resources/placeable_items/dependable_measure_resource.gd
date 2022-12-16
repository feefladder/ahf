extends MeasureResource
class_name DependableMeasureResource

export(Resource) var depends_on #PlaceableResource

func should_enable(block):
    return block in depends_on.blocks_placed

func _is_dirty():
    return blocks_placed.size() == depends_on.blocks_placed.size()
