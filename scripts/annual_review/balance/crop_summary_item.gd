extends Node

var calculation: String
# var total: float
var resource: CropResource
# Called when the node enters the scene tree for the first time.
func _ready():
    $Title.text = resource.resource_name
    # yield × area × fertility × price = total
    $Calculation.text = calculation
    # $Total.text = "%.2f" % total
    $Icon.texture = resource.image


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
