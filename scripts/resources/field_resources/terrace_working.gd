extends Resource
class_name Terrace

signal set_mouse(to_what)

var current_block: FieldBlock
var fsm: MeasureResource
export(Resource) var incomplete_row = preload("res://scripts/resources/field_resources/terrace_incomplete_row.gd")
export(Resource) var completed_row = preload("res://scripts/resources/field_resources/terrace_completed_row.gd")
export(Resource) var completed_terraces
export(StreamTexture) var mouse_paused
export(PackedScene) var mouse_working
# timer
func enter():
    current_block.start(fsm.time_required)
    current_block.connect("mouse_exited", self, "pause")
    current_block.connect("timeout", self, "finish")
    current_block.connect("mouse_entered", self, "resume")
    emit_signal("set_mouse", mouse_working)

func should_enable(field_block):
    # only enable the current block
    return field_block == current_block

func pause():
    current_block.pause()
    emit_signal("set_mouse", mouse_paused)

func resume():
    current_block.resume()
    emit_signal("set_mouse", mouse_working)

func finish():
    current_block.disconnect("mouse_exited", self, "pause")
    current_block.disconnect("timeout", self, "finish")
    current_block.disconnect("mouse_entered", self, "resume")
    current_block.place(self)
    fsm.num_placed += 1
    exit()

func exit():
    if fsm.num_placed >= fsm.field_resource.size_x * fsm.field_resource.size_y:
        fsm.next_state(completed_terraces)
    elif fsm.num_placed % fsm.field_resource.size_x:
        fsm.next_state(incomplete_row)
    else:
        fsm.next_state(completed_row)
