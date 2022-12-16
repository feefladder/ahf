extends StructuralMeasureResource
class_name MeasureImprovementResource

export(Resource) var depends_on #PlaceableResource

func should_enable(block):
    return block.has("structural_measure",depends_on.resource_name)
