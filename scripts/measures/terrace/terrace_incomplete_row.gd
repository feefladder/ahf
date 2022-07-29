extends MeasureState

func should_enable(field_block):
    # only enable the current row, where there are no terraces yet
    return field_block.y == fsm.completed[-1].y and not field_block.has(fsm.resource)

func exit():
    fsm.change_to("working")
