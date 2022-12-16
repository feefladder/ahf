extends BuyMenu
class_name CropHandler

export(NodePath) var asset_manager_path = NodePath("../../AssetManager")
export(NodePath) var field_path = NodePath("../../Background/Field")

export(PackedScene) var planting_scene = preload("res://scenes/mouse/planting.tscn")


var current_crop

onready var asset_manager = get_node(asset_manager_path)
onready var field = get_node(field_path)

func _on_tab_changed(which: BuyMenuItem):
    if which != null:
        field.enable_all()
        current_crop = which.resource

func fieldblock_pressed(block: FieldBlock):
    if current_crop:
        if current_crop.resource_name == "remove":
            # warning-ignore:return_value_discarded
            try_remove_crop(block)
        else:
            # warning-ignore:return_value_discarded
            try_plant_crop(block)

func try_plant_crop(block) -> bool:
    if not asset_manager.has_enough(current_crop.unit_price, current_crop.unit_labour):
        return false
    if database.write_block_if_empty(block.x, block.y, "crop", current_crop.resource_name):
        asset_manager.decrease_assets(current_crop.unit_price, current_crop.unit_labour)
        block.update_to_db("crop")
        return true
    else:
        return false

func try_remove_crop(block) -> bool:
    var block_crop = database.get_block_resource(block.x, block.y, "crop")
    if database.empty_block_type(block.x, block.y, "crop"):
        asset_manager.increase_assets(block_crop.unit_price, block_crop.unit_labour)
        block.update_to_db("crop")
        return true
    else:
        return false
