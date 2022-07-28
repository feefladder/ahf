extends Node

signal wanted_to_plant_crop(field_block, crop)
signal wanted_to_remove_crop(field_block)

enum States {
    STATE_IDLE,
    STATE_PLANTING_CROPS,
    STATE_REMOVING_CROPS,
    STATE_APPLYING_MEASURES,
}

var current_state = States.STATE_IDLE
var current_crop#: CropResource

func _on_BuyMenuItem_clicked(a_buy_menu_item: BuyMenuItem):
    if a_buy_menu_item.resource is CropResource:
        current_crop = a_buy_menu_item.resource
        if(a_buy_menu_item.resource.name == "remove"):
            Input.set_custom_mouse_cursor(load("res://Assets/UI/mouse_icons/shovel_icon.png"))
            current_state = States.STATE_REMOVING_CROPS
        else:
            Input.set_custom_mouse_cursor(load("res://Assets/UI/mouse_icons/seedling_icon.png"))
            current_state = States.STATE_PLANTING_CROPS

func _on_Field_field_pointed(a_block):
    match current_state:
        States.STATE_IDLE:
            print("field clicked, but idle!", a_block)
        States.STATE_PLANTING_CROPS:
            emit_signal("wanted_to_plant_crop", a_block, current_crop)
        States.STATE_REMOVING_CROPS:
            emit_signal("wanted_to_remove_crop", a_block)
        States.STATE_APPLYING_MEASURES:
            print("field clicked while applying measures", a_block)
        _:
            print("field clicked while match not implemented, wut? ", current_state)

func reset_state():
    current_state = States.STATE_IDLE
    Input.set_custom_mouse_cursor(null)
