extends BuyResource
class_name PlaceableResource

export(Array) var blocks_placed := []

func should_enable(block) -> bool:
    return not block in blocks_placed
