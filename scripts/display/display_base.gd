extends Node2D
class_name DisplayBase

func _ready():
    add_to_group("displays")

func start_year() -> void:
    print_debug("non-overridden start_year in ",self)
