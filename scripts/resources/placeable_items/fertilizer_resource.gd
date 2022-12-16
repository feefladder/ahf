extends PlaceableResource
class_name FertilizerResource

export(float) var soil_structure_effect
export(float) var long_term_fertilization

func should_enable(block) -> bool:
    return block.is_empty("fertilization")
