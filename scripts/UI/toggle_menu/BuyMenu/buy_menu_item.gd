extends ToggleButton
class_name BuyMenuItem

var resource: BuyResource
var field: Field
var current_block: FieldBlock
var asset_manager: AssetManager
var controller: Node

var completed: Array = []
var num_placed :int = 0
var fully_implemented := false


func _ready():
    $Icon.texture = resource.image
    $Title.text = tr(resource.resource_name)

