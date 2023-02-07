extends CanvasItem
class_name Stat

export(String) var type
export(String) var unit

func _ready() -> void:
    $Title.text = type

func _on_stat_changed(which: String, new_amount: float) -> void:
    if not which is String:
        return

    if which == type:
        $Amount.text = String(new_amount) + unit


func _on_AssetController_asset_changed(which, new_amount):
    _on_stat_changed(which, new_amount)
