extends Node
class_name BigMenuToggleItem

var resource: BuyResource

signal item_pressed(which, is_pressed)

# Called when the node enters the scene tree for the first time.
func _ready():
    $Title.text = resource.resource_name

func set_toggle(to_what: bool) -> void:
    $CheckBox.set_pressed_no_signal(to_what)

func _on_CheckBox_pressed():
    emit_signal("item_pressed", self, $CheckBox.pressed)
