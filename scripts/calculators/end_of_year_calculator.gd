extends Node
class_name CalculatorEOY

signal summary_completed(summary)

export(NodePath) var eoy_button_path = "/root/Loader/AssetManager/NextYearButton"
onready var eoy_button = get_node(eoy_button_path)
var summary: SummaryResource

func _ready():
    assert(eoy_button.connect("next_year_requested", self, "_on_next_year_requested") == 0)
    assert(connect("summary_completed", eoy_button, "_on_summary_completed") == 0)

func _on_next_year_requested():
    make_summary()
    printerr(summary)
    emit_signal("summary_completed", summary)

func make_summary():
    printerr("Non-overridden make_summary() in ", self.name)
