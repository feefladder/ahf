extends Node
class_name ExpensesDisplay

export(PackedScene) var asset_sum_item_scene

export(NodePath) var crop_sum_container_path
export(NodePath) var asset_sum_container_path
onready var crop_sum_container: CropExpensesContainer = get_node(crop_sum_container_path)
onready var asset_sum_container = get_node(asset_sum_container_path)

func add_crop_summary(summary: FieldSummaryResource):
    crop_sum_container.add_crop_summary(summary)

func add_asset_summary(summary: AssetSummaryResource):
    for resource in summary.expenses:
        # this is an income
        var asset_sum_item = asset_sum_item_scene.instance()
        asset_sum_item.resource = resource
        asset_sum_item.amount = summary.expenses[resource]
        asset_sum_container.add_child(asset_sum_item)
    for resource in summary.persistent_expenses:
        printerr("persistent expenses not implemented yet!")
