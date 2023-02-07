extends ToggleButton
class_name BuyMenuItem

var resource: BuyResource
# var field: Field
var current_block: FieldBlock
var controller: Node

func _ready():
    $Icon.texture = resource.image
    $Title.set_text(resource.resource_name)
