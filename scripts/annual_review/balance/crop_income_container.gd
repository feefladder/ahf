extends AnnualReviewBase
class_name CropIncomeContainer

export(PackedScene) var crop_summary_item_packedscene

const calculation = "%.2f x %.2f x %.2f = %.2f"
var crop_income := 0.0

func show_review() -> void:
    var field_resource: FieldResource = db.static_resources["primary_field"]

    var crop_sum: Array = db.get_avg_summary(db.CROP_SUM_TABLE, "yield", "crop")
    for c_dict in crop_sum:
        var c_resource: CropResource = db.static_resources[c_dict["crop"]]
       
        var area: float = field_resource.field_block_area*c_dict["crop_n"]
        var avg_yield: float = c_dict["yield_avg"]
        var price: float = c_resource.sell_price
        var total: float = area*avg_yield*price

        var crop_item = crop_summary_item_packedscene.instance()
        crop_item.resource = c_resource
        crop_item.calculation = calculation % [avg_yield, area, price, total]
        add_child(crop_item)
        crop_income += total
    

