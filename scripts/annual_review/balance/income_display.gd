extends AnnualReviewBase
class_name IncomeDisplay

signal income_changed(to_what)

export(PackedScene) var asset_sum_item_scene

export(NodePath) var crop_sum_container_path
export(NodePath) var asset_sum_container_path

var total_income := 0.0

onready var asset_sum_container = get_node(asset_sum_container_path)

func show_review():#dict: Dictionary):
    for ass_dict in db.get_asset_summary("amount*unit_price<0"):
        #income
        add_income(ass_dict)
    $VBoxContainer/Total/Amount.text = "%0.2f" % total_income
    emit_signal("income_changed", total_income)

func add_income(ass_dict: Dictionary) -> void:
    var asset_sum_item = asset_sum_item_scene.instance()
    asset_sum_item.resource = db.get_resource(ass_dict["name"])
    asset_sum_item.dict = ass_dict
    asset_sum_container.add_child(asset_sum_item)
    total_income -= ass_dict["amount"]*ass_dict["unit_price"]

