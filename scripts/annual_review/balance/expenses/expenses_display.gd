extends CategoryReview
class_name AssetExpensesSummary

export(PackedScene) var asset_sum_item_scene

export(NodePath) var crop_sum_container_path
export(NodePath) var asset_sum_container_path

var total_expenses := 0.0

onready var asset_sum_container = get_node(asset_sum_container_path)
func get_summary() -> Array:
    var arr: Array =  db.get_asset_summary("amount*unit_price>0")
    var sum := []
    for item in arr:
        if not db.static_resources[item["name"]] is CropResource:
            sum.append(item)
    return sum


func make_calculation(dict: Dictionary) -> String:
    var cost = abs(dict["amount"]*dict["unit_price"])
    total += cost
    return "%d x %.2f = %.2f" % [
        abs(dict["amount"]),
        abs(dict["unit_price"]),
        cost
    ]

func call_total_calculated() -> void:
    get_tree().call_group("annual_review", "add_expense", total)
