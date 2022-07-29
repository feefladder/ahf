extends MeasureState
# timer

func enter():
    fsm.current_block.start(fsm.resource.time_required)
    fsm.current_block.connect("timeout", self, "finish")

func fieldblock_pressed(which) -> void:
    print(which)
    which.resume()

func fieldblock_unpressed(which) -> void:
    print("unpressed which")
    which.pause()

func should_enable(field_block):
    # only enable the current block
    return field_block == fsm.current_block

func finish(which):
    assert(fsm.current_block == which)
    which.apply_measure(fsm.resource)
    fsm.completed.append(which)
    fsm.num_placed += 1
    exit()

func exit():
    if fsm.num_placed >= fsm.field.field_resource.size_x * fsm.field.field_resource.size_y:
        fsm.completed()
    elif fsm.num_placed % fsm.field.field_resource.size_x:
        fsm.change_to("incomplete")
    else:
        fsm.change_to("completed_row")
