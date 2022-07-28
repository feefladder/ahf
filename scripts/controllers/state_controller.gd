extends Node
class_name StateController

#signal state_changed(to_what, item)
#signal wanted_to_plant_crop(field_block, crop)
#signal wanted_to_remove_crop(field_block)
#signal wanted_to_apply_measure(field_block, measure)
#signal started_work(measure)

export(NodePath) var crop_handler_path = "CropHandler"
export(Dictionary) var tabs

onready var crop_handler = get_node(crop_handler_path)
#var current_state = Enums.States.STATE_IDLE
var current_item: BuyResource
var current_node: TabMenu

func _ready():
    print("crop_handler_path: ", crop_handler_path)
#    assert(connect("wanted_to_plant_crop", crop_handler, "try_plant_crop") == 0)
#    assert(connect("wanted_to_remove_crop", crop_handler, "try_remove_crop") == 0)

func _on_tab_changed(a_tab):
    if current_node:
        current_node.deactivate()
    if not a_tab:
        return
    current_node = get_node(a_tab.title + "Menu")
    current_node.activate()

func _on_fieldblock_pressed(a_block):
    if current_node:
        if current_node.has_method("field_clicked"):
            current_node.field_clicked(a_block)
