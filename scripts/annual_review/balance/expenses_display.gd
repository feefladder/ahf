extends Node
class_name ExpensesDisplay

signal expenses_changed(total)

export(PackedScene) var asset_sum_item_scene

export(NodePath) var crop_sum_container_path
export(NodePath) var asset_sum_container_path

var total_expenses := 0.0

onready var crop_sum_container: CropExpensesContainer = get_node(crop_sum_container_path)
onready var asset_sum_container = get_node(asset_sum_container_path)

func add_expense(amount: float) -> void:
    total_expenses += amount
    $VBoxContainer/Total/Amount.text = "%0.2f" % total_expenses
    emit_signal("expenses_changed", total_expenses)

func add_crop_summary(summary: FieldSummaryResource):
    add_expense(crop_sum_container.add_crop_summary(summary))

func add_asset_summary(summary: AssetSummaryResource):
    for resource in summary.expenses:
        # this is an income
        var asset_sum_item = asset_sum_item_scene.instance()
        asset_sum_item.resource = resource
        asset_sum_item.amount = summary.expenses[resource]
        asset_sum_container.add_child(asset_sum_item)

        add_expense(asset_sum_item.amount)
    for resource in summary.persistent_expenses:
        printerr("persistent expenses not implemented yet!")
