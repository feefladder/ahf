extends Sprite

func _process(_delta):
    scale = OS.get_real_window_size() / texture.get_size()
