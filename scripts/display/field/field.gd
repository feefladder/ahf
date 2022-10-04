extends YSort
class_name Field
# the Field manages:
# - instantiation of FieldBlocks
# - passing click events of FieldBlocks to the StateManager
# - keeping track of different measures that are applied and takes note of them

#signal field_pointed(a_block)

export(Resource) var summary
export(Resource) var field_resource
export(NodePath) var state_controller_path

var state_controller: StateController

var field_block_matrix: Array #2D array actually
var is_dragging_over_field: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
    state_controller = get_node(state_controller_path)
    #initialize the field
    print(field_resource)
    for x in range(field_resource.size_x):
        field_block_matrix.append([])
        for y in range(field_resource.size_y):
            var field_block = field_resource.field_block_scene.instance()
            field_block_matrix[x].append(field_block)
            field_block.position = (field_resource.dx*x+field_resource.dy*y)*scale
            field_block.x = x
            field_block.y = y
            field_block.scale = scale
            field_block.name = "block_%d%d" % [x, y]
#            field_block.disable()
            field_block.connect("pressed", state_controller, "_on_fieldblock_pressed")
            field_block.connect("unpressed", state_controller, "_on_fieldblock_unpressed")
            add_child(field_block)

#    assert(connect("field_pointed", state_controller, "_on_field_pointed") == 0)

func place_pump(pump_image: StreamTexture):
    var sprite = Sprite.new()
    sprite.texture = pump_image
    sprite.position = field_resource.dx*(field_resource.size_x+1)+field_resource.dy*(field_resource.size_y+1)
    sprite.position *= scale
    sprite.name = "pump"
    sprite.scale = scale
    add_child(sprite)

func find_block(a_block: FieldBlock) -> Dictionary:
    for y in field_block_matrix.size():
        for x in field_block_matrix[y].size():
            if field_block_matrix[y][x] == a_block:
                return {"y": y, "x": x}
    # this should never happen
    return {"x": null, "y": null}


func set_enable_with_measure(measure):
    for column in field_block_matrix:
        for field_block in column:
            if measure.should_enable(field_block):
                field_block.enable()
            else:
                field_block.disable()

func disable_except(a_block: FieldBlock):
    for column in field_block_matrix:
        for field_block in column:
            if field_block == a_block:
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

func remove_crops() -> void:
    for row in field_block_matrix:
        for field_block in row:
            if not field_block.has_crop:
                continue

            if not field_block.crop_resource.persistent:
                field_block.remove_crop()
