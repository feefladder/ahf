extends MeasureState
class_name TerraceCompletedRow
# timer
func should_enable(field_block):
    # only enable the current row, where there are no terraces yet
    for block in fsm.completed:
        if block.y + 1 == field_block.y or block.y - 1 == field_block.y:
            return not field_block.has(fsm.resource)
    return false

func exit():
    fsm.change_to("working")
