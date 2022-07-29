extends MeasureStateResource
class_name TerraceCompletedRow
# timer
func should_enable(field_block):
    # only enable the current row, where there are no terraces yet
    var enable := false
    for row in fsm.rows:
        if row + 1 == field_block.y or row - 1 == field_block.y:
            enable = true
    return enable and not field_block.has(fsm.resource)
