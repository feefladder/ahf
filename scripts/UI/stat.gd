extends CanvasItem
class_name Stat

export(String) var type
export(String) var unit

func _ready():
    $Title.text = type

func _on_stat_changed(new_amount: float):
    $Amount.text = String(new_amount) + unit
