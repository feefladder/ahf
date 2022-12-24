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
    $VBoxContainer/Total/Amount.text = "%0.2f" % total_income
    emit_signal("income_changed", total_income)

