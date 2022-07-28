extends TabMenu
class_name CropHandler


export(NodePath) var asset_manager_path

var asset_manager: AssetManager

func _ready():
    asset_manager = get_node(asset_manager_path)

func try_plant_crop(a_block, a_crop):
    if not a_block.has_crop:
        if not asset_manager.decrease_assets(a_crop.unit_price, a_crop.unit_labour):
            a_block.plant_crop(a_crop)

func try_remove_crop(a_block):
    if a_block.has_crop:
        asset_manager.increase_assets(a_block.crop_resource.unit_price, a_block.crop_resource.unit_labour)
        a_block.remove_crop()
