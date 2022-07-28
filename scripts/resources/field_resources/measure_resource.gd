extends BuyResource
class_name MeasureResource

signal set_mouse(to_what)
signal measure_completed()

export(float) var time_required = 1
export(float) var erosion_reduction
export(float) var fertility_increase
export(float) var salinity_effect

export(PackedScene) var scene
export(Resource) var state

var field_resource: FertilityResource
var num_placed: int
var completed = []

func should_enable(a_block: FieldBlock) -> bool:
    return state.should_enable(a_block)

func change_to(next_state_resource):
    # to be called by state resources themselves
    state.free()
    state = next_state_resource
    state.fsm = self
    state.enter()

func field_clicked(a_block: FieldBlock):
    if state.has_method("field_clicked"):
        state.field_clicked()
