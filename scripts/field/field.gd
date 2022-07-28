extends YSort
class_name Field
# the Field manages:
# - instantiation of FieldBlocks
# - passing click events of FieldBlocks to the StateManager
# - keeping track of whether a measure or crop can be applied to a fieldblock
# - keeping track of different measures that are applied and takes note of them
# - crop and fertility calculations at the end of the year

signal field_pointed(a_block)

export(Resource) var summary
export(Resource) var fertility

export var field_block_scene: PackedScene
export(int) var x_max
export(int) var y_max
export(Vector2) var dx
export(Vector2) var dy

export(NodePath) var state_controller_path

onready var state_controller = get_node(state_controller_path)

var field_block_matrix: Array #2D array actually
var is_dragging_over_field: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
    #initialize the field
    for x in range(x_max):
        field_block_matrix.append([])
        for y in range(y_max):
            var field_block = field_block_scene.instance()
            field_block_matrix[x].append(field_block)
            field_block.position = dx*x+dy*y
            field_block.x = x
            field_block.y = y
#            field_block.disable()
            field_block.connect("pressed", state_controller, "_on_fieldblock_pressed")
            
            add_child(field_block)

    assert(connect("field_pointed", state_controller, "_on_field_pointed") == 0)

func make_summary() -> FieldSummaryResource:
    summary.start_fertility = fertility
    for row in field_block_matrix:
        for field_block in row:
            if field_block.has_crop:
                summary.add_crop_data(field_block.crop_resource, field_block.calculate_yield(fertility))
                field_block.remove_crop()
            # TODO: add magic to actually calculate fertility influence
    
    # TODO: fertility calculations
    return summary

func disable_all_except(a_block: FieldBlock) -> void:
    for column in field_block_matrix:
        for field_block in column:
            if not field_block == a_block:
                field_block.disable()

func find_block(a_block: FieldBlock) -> Dictionary:
    for y in field_block_matrix.size():
        for x in field_block_matrix[y].size():
            if field_block_matrix[y][x] == a_block:
                print("(", x, ", ", y, ")")
                return {"y": y, "x": x}
    # this should never happen
    return {"x": null, "y": null}

func disable_all_except_column(a_block: FieldBlock) -> void:
    var pt = find_block(a_block)
    for y in field_block_matrix.size():
        if y == pt.y:
            continue
        for field_block in field_block_matrix[y]:
            field_block.disable()

func disable_all_except_row(a_block: FieldBlock) -> void:
    var pt = find_block(a_block)
    for column in field_block_matrix:
        for x in column.size():
            if x != pt.x:
                column[x].disable()

func disable_all_with(something: BuyResource):
    for column in field_block_matrix:
        for field_block in column:
            if field_block.has(something):
                field_block.disable()

func enable_all_without(something: BuyResource):
    for column in field_block_matrix:
        for field_block in column:
            if not field_block.has(something):
                field_block.enable()

func set_enable_with_measure(measure):
    for column in field_block_matrix:
        for field_block in column:
            if measure.should_enable(field_block):
                field_block.enable()
            else:
                field_block.disable()

func disable_all() -> void:
    for column in field_block_matrix:
        for field_block in column:
            field_block.disable()

func enable_all() -> void:
    for column in field_block_matrix:
        for field_block in column:
            field_block.enable()
