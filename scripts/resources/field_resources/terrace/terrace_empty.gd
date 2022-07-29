extends MeasureStateResource
class_name TerraceEmpty

# timer
func should_enable(field_block):
    # we only want to start building terraces on the bottom row
    return field_block.y == 0
