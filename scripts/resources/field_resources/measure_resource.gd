extends BuyResource
class_name MeasureResource

export(float) var time_required = 1
export(float) var erosion_reduction
export(float) var fertility_increase
export(float) var salinity_effect

export(PackedScene) var scene
export(Dictionary) var states


var num_placed: int
var completed = []
var current_block: FieldBlock
