extends MeasureStateResource
class_name TerraceWorking

signal set_mouse(to_what)

export(Resource) var incomplete_row
export(Resource) var completed_row
export(Resource) var completed_terraces
export(StreamTexture) var mouse_paused
export(PackedScene) var mouse_working
# timer

func enter():
    fsm.current_block.start(fsm.time_required)
    assert(fsm.current_block.connect("timeout", self, "finish") == 0)
    assert(fsm.current_block.connect("pressed", self, "resume") == 0)
    assert(fsm.current_block.connect("un_pressed", self, "pause") == 0)
    emit_signal("set_mouse", mouse_working)

func field_clicked(a_block: FieldBlock):
    print("clicked a block!")

func should_enable(field_block):
    # only enable the current block
    return field_block == fsm.current_block

func pause(which):
    which.pause()
    emit_signal("set_mouse", mouse_paused)

func resume(which):
    which.resume()
    emit_signal("set_mouse", mouse_working)

func finish(which):
    fsm.current_block.disconnect("un_pressed", self, "pause")
    fsm.current_block.disconnect("timeout", self, "finish")
    fsm.current_block.disconnect("pressed", self, "resume")
    fsm.current_block.apply_measure(fsm)
    fsm.completed.append(fsm.current_block)
    fsm.num_placed += 1
    exit()

func exit():
    if fsm.num_placed >= fsm.field_resource.size_x * fsm.field_resource.size_y:
        fsm.change_to(completed_terraces)
    elif fsm.num_placed % fsm.field_resource.size_x:
        fsm.change_to(incomplete_row)
    else:
        fsm.change_to(completed_row)
