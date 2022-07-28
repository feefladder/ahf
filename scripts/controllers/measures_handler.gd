extends TabMenu
class_name MeasuresHandler

signal tab_changed()

export(NodePath) var asset_manager_path = "../../AssetManager"
export(NodePath) var field_path = "../../Field"

var current_measure: BuyResource

onready var asset_manager = get_node(asset_manager_path)
onready var field = get_node(field_path)

func _ready():
    assert(connect("deactivated", self, "_on_deactivate") == 0)
    assert(connect("activated", self, "_on_activated") == 0)

func _on_tab_changed(which: BuyMenuItem):
    current_measure = which.resource
    emit_signal("tab_changed")
    print("changed to: ", current_measure.resource_name)

func field_clicked(a_block) -> void:
    if a_block.has(current_measure):
        return
    if current_measure is MeasureResource:
        if asset_manager.has_enough(current_measure.unit_price, current_measure.unit_labour):
            field.set_enable_with_measure(current_measure)
            a_block.start(current_measure.time_required)
            a_block.connect("mouse_exited", current_measure, "pause")
            a_block.connect("mouse_entered", current_measure, "resume")
            a_block.connect("timeout", self, "_on_block_timeout")
            connect("tab_changed", a_block, "stop_timer")

func _on_block_timeout(a_block: FieldBlock):
    if current_measure is MeasureResource:
        if asset_manager.decrease_assets(current_measure.unit_price, current_measure.unit_labour):
            field.enable_all_without(current_measure)
            field.disable_all_except_row(a_block)
            a_block.disconnect("timeout", self, "_on_block_timeout")
            disconnect("tab_changed", a_block, "stop_timer")
            a_block.apply_measure(current_measure)

func _on_deactivate(me):
    field.disable_all()

func _on_activated(me):
    field.enable_all()
