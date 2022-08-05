extends Node
class_name IncomeDisplay

signal income_changed(to_what)

export(PackedScene) var asset_sum_item_scene

export(NodePath) var crop_sum_container_path
export(NodePath) var asset_sum_container_path
onready var crop_sum_container: CropIncomeContainer = get_node(crop_sum_container_path)
onready var asset_sum_container = get_node(asset_sum_container_path)

var total_income := 0.0

func add_income(amount: float) -> void:
    total_income += amount
    emit_signal("income_changed", total_income)

func add_crop_summary(summary: FieldSummaryResource):
#    assert(crop_sum_container.connect("crop_income_calculated", self, "add_income") == 0)
    crop_sum_container.add_crop_summary(summary)

func add_asset_summary(summary: AssetSummaryResource):
    for resource in summary.income:
        # this is an income
        var asset_sum_item = asset_sum_item_scene.instance()
        asset_sum_item.resource = resource
        asset_sum_item.amount = summary.income[resource]
        asset_sum_container.add_child(asset_sum_item)
        
        add_income(summary.income[resource])
    for resource in summary.persistent_income:
        print("adding item for: ", resource, summary.persistent_income[resource])


