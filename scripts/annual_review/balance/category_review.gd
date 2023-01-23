extends AnnualReviewBase
class_name CategoryReview

export(String) var title
export(String) var calculation_text

var summary_item_packedscene : PackedScene = preload("res://scenes/annual_review/summary_item.tscn")
var total := 0.0
var current_resource

func _ready():
    $Container/Title.text = tr(title)
    $Container/Calculation.text = tr(calculation_text)

func show_review():
    var dicts: Array = get_summary()
    if dicts.size() == 0:
        queue_free()
    for dict in dicts:
        var item = summary_item_packedscene.instance()
        current_resource = db.static_resources[dict["name"]]
        item.image = current_resource.image
        item.title = dict["name"]
        item.calculation = make_calculation(dict)
        $Container.add_child(item)

    call_total_calculated()
    show_total()

func get_summary() -> Array:
    # get the summary from the database
    print_debug("unoverridden get_summary!")
    return []

func make_calculation(_dict: Dictionary) -> String:
    # make the calculation string. Also update total
    print_debug("unoverridden make_calculation!")
    return ""

func call_total_calculated() -> void:
    print_debug("unoverriddedn call_total_calculated!")
    return

func show_total() -> void:
    var line := ColorRect.new()
    line.anchor_left = 0.0
    line.anchor_right = 1.0
    line.color = Color("#000")
    line.rect_min_size = Vector2(0.0, 5.0)
    $Container.add_child(line)

    var total_label := Label.new()
    total_label.align = Label.ALIGN_RIGHT
    total_label.text = "%.2f" % total
    $Container.add_child(total_label)

