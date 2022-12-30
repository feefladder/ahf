extends AnnualReviewBase
class_name CropExpensesContainer

export(PackedScene) var crop_summary_item_packedscene

const calculation = "%d x %.2f = %.2f"
var crop_expenses := 0.0

func show_review() -> void:
    # var crop_sum: Array = db.get_avg_summary(db.CROP_SUM_TABLE, "yield", "crop")
    for ass_dict in db.get_asset_summary("amount<0"):
        #expense
        var c_resource = db.get_resource(ass_dict["name"])
        if not c_resource is CropResource:
            # crop resources go into the crop tab
            continue
        var total = ass_dict["amount"] * c_resource.unit_price
        var crop_item = crop_summary_item_packedscene.instance()
        crop_item.resource = c_resource
        crop_item.calculation = calculation % [ ass_dict["amount"], c_resource.unit_price, ]
        add_child(crop_item)
        crop_expenses += total

