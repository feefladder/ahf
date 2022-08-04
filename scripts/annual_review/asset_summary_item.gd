extends Node

const calculation = "%.2f x %.2f x %.2f x %.2f ="

var resource: Resource
var amount: int
# Called when the node enters the scene tree for the first time.
func _ready():
    if not resource:
        print_tree_pretty()
        printerr("Asset Summary item initialized without resource!", name)
        return

    $Title.text = resource.resource_name
    # yield × area × fertility × price = total
    $Amount.text = "%.2f" % (amount)
#    $Icon.texture = crop_resource.image


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
