extends Node

const calculation = "%.2f x %.2f x %.2f x %.2f ="

var crop_resource: CropResource
var crop_summary_data: Dictionary
var compound_fertility: float
# Called when the node enters the scene tree for the first time.
func _ready():
    $Title.text = crop_resource.resource_name
    # yield × area × fertility × price = total
    $Calculation.text = calculation % [crop_summary_data["yield"], crop_summary_data["area"], compound_fertility, crop_resource.sell_price]
    $Total.text = "%.2f" % (crop_summary_data["yield"] * crop_resource.sell_price)
    $Icon.texture = crop_resource.image


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
