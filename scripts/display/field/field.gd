extends DisplayBase
class_name Field
# the Field manages:
# - instantiation of FieldBlocks
# - passing click events of FieldBlocks to the StateManager
# -
# - keeping track of different measures that are applied and passes them to the database


#signal field_pointed(a_block)

export(Resource) var summary
export(Resource) var field_resource
export(NodePath) var state_controller_path
export(NodePath) var database_path = NodePath("/root/Database")

var state_controller: StateController
var database: Database

var field_block_matrix: Array #2D array actually
var is_dragging_over_field: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
    state_controller = get_node(state_controller_path)
    database = get_node(database_path)

func _init_field():
    for x in range(field_resource.size_x):
        field_block_matrix.append([])
        for y in range(field_resource.size_y):
                # warning-ignore:return_value_discarded
                database.add_block(x,y)

                var field_block = field_resource.field_block_scene.instance()
                field_block_matrix[x].append(field_block)
                field_block.position = (field_resource.dx*x+field_resource.dy*y)*scale
                field_block.x = x
                field_block.y = y
                field_block.scale = scale
                field_block.name = "block_%d%d" % [x, y]
                field_block.connect("pressed", state_controller, "_on_fieldblock_pressed")
                field_block.connect("unpressed", state_controller, "_on_fieldblock_unpressed")
                add_child(field_block)

func place_pump(pump_image: StreamTexture):
    var sprite = Sprite.new()
    sprite.texture = pump_image
    sprite.position = field_resource.dx*(field_resource.size_x+1)+field_resource.dy*(field_resource.size_y+1)
    sprite.position *= scale
    sprite.name = "pump"
    sprite.scale = scale
    add_child(sprite)

func set_enable_with(item: PlaceableResource) -> void:
    for column in field_block_matrix:
        for field_block in column:
            if item.should_enable(field_block):
                field_block.enable()
            else:
                field_block.disable()

func disable_except(block: FieldBlock) -> void:
    for column in field_block_matrix:
        for field_block in column:
            if field_block.x == block.x and field_block.y == block.y:
                field_block.enable()
            else:
                field_block.disable()

func _on_Database_database_loaded() -> void:
    _init_field()


func start_year():
    update_all_to_db()

func update_all_to_db():
    for column in field_block_matrix:
        for field_block in column:
            field_block.update_all_to_db()
