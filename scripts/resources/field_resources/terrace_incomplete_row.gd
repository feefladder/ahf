extends MeasureResource

var current_block: FieldBlock
var fsm
var incomplete_row
var completed_row
export(Resource) var terrace_working
# timer
func should_enable(field_block):
    # only enable the current row, where there are no terraces yet
    return field_block.y == fsm.rows[-1] and not field_block.has(fsm.resource)

func exit():
    fsm.next_state(terrace_working)
