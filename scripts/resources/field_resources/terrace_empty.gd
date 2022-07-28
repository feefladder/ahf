extends MeasureResource

var current_block: FieldBlock
var fsm
var incomplete_row
var completed_row
export(Resource) var terrace_working = preload("res://scripts/resources/field_resources/terrace_working.gd")
# timer
func should_enable(field_block):
    # we only want to start building terraces on the bottom row
    return field_block.y == 0

func exit():
    fsm.next_state(terrace_working)
