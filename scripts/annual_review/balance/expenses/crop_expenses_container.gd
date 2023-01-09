extends CategoryReview
class_name CropExpensesSummary

const calculation = "%d x %.2f = %.2f"

func get_summary() -> Array:
    var arr: Array =  db.get_asset_summary("amount*unit_price>0")
    var sum := []
    for item in arr:
        if db.static_resources[item["name"]] is CropResource:
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
    

# func show_review() -> void:
#     # var crop_sum: Array = db.get_avg_summary(db.CROP_SUM_TABLE, "yield", "crop")
#     for ass_dict in db.get_asset_summary("amount*unit_price>0"):
#         #expense
#         var c_resource = db.get_resource(ass_dict["name"])
#         if not c_resource is CropResource:
#             # crop resources go into the crop tab
#             continue
#         var total = ass_dict["amount"] * c_resource.unit_price
#         var crop_item = crop_summary_item_packedscene.instance()
#         crop_item.resource = c_resource
#         crop_item.calculation = calculation % [
#             ass_dict["amount"],
#             c_resource.unit_price,
#             total
#         ]
#         add_child(crop_item)
#         crop_expenses += total
#     get_tree().call_group("total_displays","add_expense_to_total", crop_expenses)
