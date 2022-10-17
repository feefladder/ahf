extends Node
class_name ToggleButtonContainer

signal tab_changed(to_what)

export(Color) var modulateColorHover = Color("ccc")
export(Color) var modulateColorPressed = Color("999")
export(Color) var modulateColorNormal = Color("fff")
export(NodePath) var tooltip_path
export(NodePath) var target_path

var selected_button: ToggleButton = null

onready var target_node = get_node(target_path)
onready var tooltip: Tooltip = get_node(tooltip_path)
# Called when the node enters the scene tree for the first time.
func _ready():
    printerr(connect("tab_changed",target_node,"_on_tab_changed"))
    _connect_children()

func _connect_children():
    for a_button in self.get_children():
        if a_button is ToggleButton:
            a_button.connect("hovered",self,"_on_button_hovered")
            a_button.connect("un_hovered",self,"_on_button_un_hovered")
            a_button.connect("pressed",self,"_on_button_pressed")

            a_button.connect("hovered", tooltip, "_on_object_hovered")
            a_button.connect("un_hovered", tooltip, "_on_object_un_hovered")

func deselect():
    if selected_button != null:
        selected_button.modulate = modulateColorNormal
        selected_button = null
        emit_signal("tab_changed", selected_button)

func _on_button_pressed(a_button: ToggleButton):
    a_button.modulate = modulateColorPressed
    if (selected_button != null):
        selected_button.modulate = modulateColorNormal
    selected_button = a_button
    emit_signal("tab_changed", selected_button)

func _on_button_hovered(a_button: ToggleButton):
    if a_button != selected_button:
        a_button.modulate = modulateColorHover

func _on_button_un_hovered(a_button: ToggleButton):
    if a_button != selected_button:
        a_button.modulate = modulateColorNormal
