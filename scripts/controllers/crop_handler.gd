extends BuyMenu
class_name CropHandler


export(NodePath) var asset_manager_path = "../../AssetManager"
export(NodePath) var field_path = "../../Background/Field"

export(PackedScene) var planting_scene = preload("res://scenes/mouse/planting.tscn")

var current_crop: CropResource

onready var asset_manager = get_node(asset_manager_path)
onready var field = get_node(field_path)

func _on_tab_changed(which: BuyMenuItem):
    if which != null:
        field.enable_all()
        current_crop = which.resource

func fieldblock_pressed(a_block: FieldBlock):
    if current_crop:
        if current_crop.resource_name == "remove":
            try_remove_crop(a_block)
        else:
            try_plant_crop(a_block)

func try_plant_crop(a_block):
    if not a_block.has_crop:
        if asset_manager.decrease_assets(current_crop.unit_price, current_crop.unit_labour):
            a_block.add_crop(current_crop)
            var planting = planting_scene.instance()
            planting.crop = a_block.get_node("Crop")
            a_block.add_child(planting)

func try_remove_crop(a_block):
    if a_block.has_crop:
        asset_manager.increase_assets(a_block.crop_resource.unit_price, a_block.crop_resource.unit_labour)
        a_block.remove_crop()

func next_year():
    for row in field.field_block_matrix:
        for field_block in row:
            if not field_block.crop.persistent:
                field_block.remove_crop()
