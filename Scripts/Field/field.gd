extends YSort
class_name Field

signal field_pointed(a_block)

export var field_block_scene: PackedScene
export(int) var x_max
export(int) var y_max
export(Vector2) var dx
export(Vector2) var dy

var field_block_matrix: Array #2D array actually
var is_dragging_over_field: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
    for x in range(x_max):
        field_block_matrix.append([])
        for y in range(y_max):
            var field_block = field_block_scene.instance()
            field_block_matrix[x].append(field_block)
            field_block.position = dx*x+dy*y
            field_block.connect("hovered", self, "_on_FieldBlock_hovered")
            field_block.connect("mouse_clicked", self, "_on_FieldBlock_mouse_clicked")
            add_child(field_block)

func _input(event):
    if(event is InputEventMouseButton and event.pressed == false):
        is_dragging_over_field = false

func  _on_FieldBlock_hovered(a_block: FieldBlock):
    if(is_dragging_over_field):
        emit_signal("field_pointed",a_block)
    
func  _on_FieldBlock_mouse_clicked(a_block: FieldBlock):
    is_dragging_over_field = true
    emit_signal("field_pointed",a_block)
