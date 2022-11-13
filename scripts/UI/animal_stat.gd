extends Node

export(Resource) var type

func _on_stat_changed(which, number: int) -> void:
    if which is String:
        return

    if which == type:
        $Amount.text = String(number)
