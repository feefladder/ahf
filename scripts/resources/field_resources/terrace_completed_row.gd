extends MeasureResource

var current_block: FieldBlock
var fsm
var incomplete_row
var completed_row
export(Resource) var terrace_working
# timer
func should_enable(field_block):
    # only enable the current row, where there are no terraces yet
    var enable := false
    for row in fsm.rows:
        if row + 1 == field_block.y or row - 1 == field_block.y:
            enable = true
    return enable and not field_block.has(fsm.resource)

func exit():
    fsm.next_state(terrace_working)
