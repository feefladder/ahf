extends ToggleButton
class_name BuyMenuItem

var resource: BuyResource
var field: Field
var current_block: FieldBlock

var completed: Array = []
var num_placed :int = 0
var fully_implemented := false
var state: Node

func instantiate_initial():
    state = Node.new()
    state.set_script(resource.states["initial"])
    state.fsm  = self
    add_child(state)

func get_min_number():
    if not state:
        instantiate_initial()
    if state.has_method("get_min_number"):
        return state.get_min_number()
    else:
        return 1

func enter():
    state.fsm = self
    field.set_enable_with_measure(state)
    
    print("entering: ", state, " from ", state.fsm)
    state.enter()

func fieldblock_pressed(a_block: FieldBlock):
    print("block pressed!")
    if state.has_method("fieldblock_pressed"):
        state.fieldblock_pressed(a_block)

func fieldblock_unpressed(a_block: FieldBlock):
    print("blcok unpressed")
    if state.has_method("fieldblock_unpressed"):
        state.fieldblock_unpressed(a_block)

func change_to(next):
    print("changing state!", next)
    state.set_script(resource.states[next])
    enter()

func completed():
    state.queue_free()
    state = null
    fully_implemented = true
    field.disable_all()
