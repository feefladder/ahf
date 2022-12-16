extends Label

export(float) var max_width = 300.0

enum Modes {
    MODE_SMALL
    MODE_MAX_WIDTH
}

var current_mode = Modes.MODE_SMALL

func _ready():
    # warning-ignore:return_value_discarded
    connect("resized",self,"maybe_set_width")

func maybe_set_width() -> void:
    if current_mode == Modes.MODE_SMALL:
        if rect_size.x > max_width:
            set_width_max()
    else:
        if get_line_count() == 1:
            set_width_small()

func set_width_small() -> void:
    rect_min_size = Vector2(0,0)
    autowrap = false
    current_mode = Modes.MODE_SMALL

func set_width_max() -> void:
    rect_min_size = Vector2(max_width,0)
    autowrap = true
    current_mode = Modes.MODE_MAX_WIDTH
