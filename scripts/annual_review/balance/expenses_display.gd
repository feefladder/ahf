extends AnnualReviewBase
class_name ExpensesDisplay

signal expenses_changed(total)

export(PackedScene) var asset_sum_item_scene

export(NodePath) var crop_sum_container_path
export(NodePath) var asset_sum_container_path

var total_expenses := 0.0

onready var asset_sum_container = get_node(asset_sum_container_path)

func show_review():
    for asset_dict in db.get_summary(db.ASSET_SUM_TABLE):
        if asset_dict["d_money"] < 0:
            #expense
            add_expense(asset_dict)
    $VBoxContainer/Total/Amount.text = "%0.2f" % total_expenses
    emit_signal("expenses_changed", total_expenses)

func add_expense(ass_dict: Dictionary) -> void:
    var asset_sum_item = asset_sum_item_scene.instance()
    asset_sum_item.resource = db.get_resource(ass_dict["name"])
    asset_sum_item.dict = ass_dict
    asset_sum_container.add_child(asset_sum_item)
    total_expenses -= ass_dict["d_money"]
