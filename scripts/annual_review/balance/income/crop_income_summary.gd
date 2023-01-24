extends CategoryReview
class_name CropIncomeSummary

var field_resource : FieldResource

func _ready():
    field_resource = db.static_resources["primary_field"]

func get_summary() -> Array:
    return db.get_avg_summary(db.CROP_SUM_TABLE, "yield", "name")

func make_calculation(dict: Dictionary) -> String:
    var area: float = field_resource.field_block_area*dict["name_n"]
    var avg_yield: float = dict["yield_avg"]
    var price: float = current_resource.sell_price
    var income: float = area*avg_yield*price
    total += income
    # make the calculation string. Also update total
    print_debug("unoverridden make_calculation!")
    return "%.2f x %.2f x %.2f = %.2f" % [avg_yield, area, price, income]


func call_total_calculated():
    get_tree().call_group("annual_review","add_income",total)
