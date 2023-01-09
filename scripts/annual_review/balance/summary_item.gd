extends Node

var calculation: String
var title: String
var image: StreamTexture
# var total: float
# var resource: CropResource = load("res://resources/crops/maize.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
    $Title.text = title
    # yield × area × fertility × price = total
    $Calculation.text = calculation
    # $Total.text = "%.2f" % total
    $Icon.texture = image


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
