extends CategoryReview
class_name AssetIncomeSummary

func get_summary() -> Array:
    return db.get_asset_summary("amount*unit_price<0")

func make_calculation(dict: Dictionary) -> String:
    var income = abs(dict["amount"]*dict["unit_price"])
    total += income
    return "%d x %.2f = %.2f" % [
        abs(dict["amount"]),
        abs(dict["unit_price"]),
        income
    ]

func call_total_calculated() -> void:
    get_tree().call_group("annual_review", "add_income", total)

# func add_income_unit(income: float, ass_dict: Dictionary) -> void:
#     var asset_sum_item = asset_sum_item_scene.instance()
#     asset_sum_item.resource = db.get_resource(ass_dict["name"])
#     asset_sum_item.dict = ass_dict
#     asset_sum_container.add_child(asset_sum_item)
    

