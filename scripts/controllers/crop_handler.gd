extends TabMenu
class_name CropHandler

signal change_mouse(to_what)

export(NodePath) var asset_manager_path = "../../AssetManager"
export(NodePath) var field_path = "../../Field"

var current_crop: CropResource


onready var asset_manager = get_node(asset_manager_path)
onready var field = get_node(field_path)

func _on_tab_changed(which: BuyMenuItem):
    if which != null:
        field.enable_all_without(which)
        current_crop = which.resource
    emit_signal("change_mouse", current_crop.image)

func field_clicked(a_block: FieldBlock):
    if current_crop:
        if current_crop.resource_name == "remove":
            try_remove_crop(a_block)
        else:
            try_plant_crop(a_block)

func try_plant_crop(a_block):
    if not a_block.has_crop:
        if asset_manager.decrease_assets(current_crop.unit_price, current_crop.unit_labour):
            a_block.plant_crop(current_crop)

func try_remove_crop(a_block):
    if a_block.has_crop:
        asset_manager.increase_assets(a_block.crop_resource.unit_price, a_block.crop_resource.unit_labour)
        a_block.remove_crop()
