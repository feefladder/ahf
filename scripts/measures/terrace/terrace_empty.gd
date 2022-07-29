extends MeasureState

func get_min_number():
    return fsm.field.field_resource.size_x
# timer
func should_enable(field_block):
    # we only want to start building terraces on the bottom row
    return field_block.y == 0

func exit():
    fsm.change_to("working")
