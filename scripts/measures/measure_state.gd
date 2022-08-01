extends Node
class_name MeasureState

var fsm
var next_key: String

func should_enable(a_block: FieldBlock) -> bool:
    print("unoverridden should_enable!")
    return not a_block.has(fsm)

func fieldblock_pressed(a_block) -> void:
    print("unoverridden fieldblock_pressed!")
    fsm.current_block = a_block
    exit()

func enter() -> void:
    print("unoverridden enter!")

func exit() -> void:
    print_debug("unoverriden exit!, not exiting!")
