extends Resource
class_name MeasureStateResource

var fsm: MeasureResource
export(Resource) var default_next_state

func should_enable(a_block: FieldBlock) -> bool:
    print("unoverridden should_enable!")
    return not a_block.has(fsm)

func field_clicked(a_block) -> void:
    print("unoverridden field clicked!")
    fsm.current_block = a_block
    exit()

func enter() -> void:
    print("unoverridden enter!")

func exit() -> void:
    print("unoverriden exit!")
    fsm.change_to(default_next_state)
