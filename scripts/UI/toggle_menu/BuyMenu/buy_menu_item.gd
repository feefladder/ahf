extends ToggleButton
class_name BuyMenuItem

#warning-ignore: unused_signal
signal change_mouse(to_what)

var resource: BuyResource
var field: Field
var current_block: FieldBlock
var asset_manager: AssetManager

var completed: Array = []
var num_placed :int = 0
var fully_implemented := false
var state: Node

func instantiate_initial():
    if resource is MeasureResource:
        state = Node.new()
        state.set_script(resource.states["initial"])
        state.fsm  = self
        add_child(state)

func get_min_number() -> int:
    if resource is MeasureResource:
        if not state:
            instantiate_initial()
        if state.has_method("get_min_number"):
            return state.get_min_number()
    return 1

func enter():
    if resource is MeasureResource:
        state.fsm = self
        field.set_enable_with_measure(state)
        print("entering: ", state, " from ", state.fsm)
        state.enter()

func apply_current_block():
    if asset_manager.decrease_assets(resource.unit_price, resource.unit_labour):
        current_block.apply_measure(resource)
        completed.append(current_block)
        num_placed += 1

func fieldblock_pressed(a_block: FieldBlock):
    if state.has_method("fieldblock_pressed"):
        state.fieldblock_pressed(a_block)

func change_to(next):
    print("changing state!", next)
    state.set_script(resource.states[next])
    enter()

func _on_completed():
    state.queue_free()
    state = null
    fully_implemented = true
    field.disable_all()
