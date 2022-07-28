extends Node
class_name BigMenuIntItem

var resource: BuyResource

signal increase_pressed(which)
signal decrease_pressed(which)

func _ready():
    $Icon.texture = resource.image
    $TypeLabel.text = resource.name
    $NumberLabel.text = String(resource.current_number)
    $Pricetag.text = String(resource.unit_price)

func change_number(new_number: int) -> void:
    resource.current_number = new_number
    $NumberLabel.text = String(resource.current_number)


func _on_DecreaseButton_pressed():
    emit_signal("decrease_pressed", self)


func _on_IncreaseButton_pressed():
    emit_signal("increase_pressed", self)
