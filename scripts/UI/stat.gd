extends CanvasItem
class_name Stat

export(String) var type
export(String) var unit

func _ready() -> void:
    $Title.text = tr(type)

func _on_stat_changed(which: String, new_amount: float) -> void:
    if not which is String:
        return

    if which == type:
        $Amount.text = String(new_amount) + unit
