extends Node
class_name AnnualReview

export(NodePath) var income_path = "VBoxContainer/HBoxContainer/Income"
export(NodePath) var expenses_path = "VBoxContainer/HBoxContainer/Expenses"

onready var income: IncomeDisplay = get_node(income_path)
onready var expenses = get_node(expenses_path)

func _on_NextYearButton_pressed():
    get_tree().get_root().remove_child(self)
    queue_free()

func add_summary(summary):
    if not summary:
        printerr("not sure what you're trying to do with: ", summary)
        return
    print("summary requested for: ", summary.type, CropResource)
    if summary is FieldSummaryResource:
        print("Makign summary for Crops!")
        income.add_crop_summary(summary)
        expenses.add_crop_summary(summary)
    elif summary is AssetSummaryResource:
        print("making summary for assets!")
        income.add_asset_summary(summary)
        expenses.add_asset_summary(summary)
    elif summary is SummaryResource:
        printerr("summary making not implemented for ", summary.get_class())
    else:
        printerr("not sure what you're trying to do with: ", summary)
