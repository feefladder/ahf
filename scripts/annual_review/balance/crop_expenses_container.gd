extends AnnualReviewBase
class_name CropExpensesContainer

export(PackedScene) var crop_summary_item_packedscene

const calculation = "%d x %.2f = %.2f"

func show_review() -> void:
    var c_resources: Dictionary = db.static_resources["crop"] #TODO: make nice

    var crop_sum: Array = db.get_avg_summary(db.CROP_SUM_TABLE, "yield", "crop")
    for c_dict in crop_sum:
        var c_resource: CropResource = c_resources[c_dict["crop"]]
       
        var amount: int = c_dict["crop_n"]
        var price: float = c_resource.unit_price
        var total: float = amount*price

        var crop_item = crop_summary_item_packedscene.instance()
        crop_item.resource = c_resource
        crop_item.calculation = calculation % [amount, price, total]
        add_child(crop_item)
