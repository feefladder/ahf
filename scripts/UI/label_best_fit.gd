extends Label
class_name LabelBestFit

var prev_text: String = text
var max_font_size : int
var font : DynamicFont

func _ready():
	# make the font local
	# maybe move to _draw, so it also works when the font is changed in-game
	# use the 
	# warning-ignore:return_value_discarded
	connect("resized", self, "best_fit_check")
	font = get("custom_fonts/font")
	if font == null:
		font = get_theme().default_font.duplicate()
		set("custom_fonts/font", font)
	max_font_size = font.size
	best_fit_check()

func get_theme():
	var control = self
	var my_theme = theme
	if my_theme != null:
		return my_theme
	while control != null && "theme" in control:
		my_theme = control.theme
		if my_theme != null:
			break
		control = control.get_parent()
	return my_theme

func _set(k, _v):
	if "text" == k:
		best_fit_check()
		text = _v

func best_fit_check():
	if font == null:
		print_debug("failed!")
		return

	font.size = max_font_size
	if autowrap:
		while get_visible_line_count() < get_line_count():
			font.size -= 1
	else:
		if rect_size.y < max_font_size:
			font.size = int(rect_size.y)
		while rect_size.x < font.get_string_size(tr(text)).x:
			font.size -= 1
