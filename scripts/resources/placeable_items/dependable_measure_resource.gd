extends StructuralMeasureResource
class_name Measure_improvement_resource

export(Resource) var depends_on #PlaceableResource

func should_enable(block):
    return true# block in depends_on.blocks_placed
