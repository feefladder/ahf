extends Node
class_name EOYCalculator

signal summary_completed(summary)

export(NodePath) var eoy_button_path = NodePath("/root/Database/AssetManager/NextYearButton")
onready var eoy_button = get_node(eoy_button_path)
var summary: SummaryResource

func _ready():
    if eoy_button.connect("next_year_requested", self, "_on_next_year_requested"):
        print_debug("eoy-button next_yar_requested connect failed")
    if connect("summary_completed", eoy_button, "_on_summary_completed"):
        print_debug("summary_completed connect failed")

func _on_next_year_requested(event: EventResource):
    summary = make_summary(event)
    emit_signal("summary_completed", summary)

func make_summary(_event: EventResource) -> SummaryResource:
    printerr("Non-overridden make_summary() in ", self.name)
    return null
