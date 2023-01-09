extends Node
class_name BigMenuIntItem

signal increase_pressed(which)
signal decrease_pressed(which)

var resource: IntResource
var amount: int =0 setget _set_number


func _ready():
    $Icon.texture = resource.image
    $TypeLabel.text = resource.resource_name
    $NumberLabel.text = String(amount)
    $Pricetag.text = String(resource.unit_price)

func _set_number(new_number: int) -> void:
    amount = new_number
    $NumberLabel.text = String(amount)


func _on_DecreaseButton_pressed():
    emit_signal("decrease_pressed", self)


func _on_IncreaseButton_pressed():
    emit_signal("increase_pressed", self)
