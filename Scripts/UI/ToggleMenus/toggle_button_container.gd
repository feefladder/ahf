extends Node
class_name ToggleButtonContainer

export(Color) var modulateColorHover = Color("ccc")
export(Color) var modulateColorPressed = Color("999")
export(Color) var modulateColorNormal = Color("fff")
export(NodePath) var tooltip_path

var selected_button: ToggleButton = null

onready var tooltip: Tooltip = get_node(tooltip_path)
# Called when the node enters the scene tree for the first time.
func _ready():
    _connect_children()

func _connect_children():
    for aButton in self.get_children():
        if aButton is ToggleButton:
            aButton.connect("hovered",self,"_on_button_hovered")
            aButton.connect("un_hovered",self,"_on_button_un_hovered")
            aButton.connect("pressed",self,"_on_button_pressed")
            
            aButton.connect("hovered", tooltip, "_on_object_hovered")
            aButton.connect("un_hovered", tooltip, "_on_object_un_hovered")

func deselect():
    if selected_button != null:
        selected_button.modulate = modulateColorNormal
        selected_button.un_select()
        selected_button = null
    _item_deselected()

func _on_button_hovered(aButton: ToggleButton):
    if aButton != selected_button:
        aButton.modulate = modulateColorHover

func _on_button_un_hovered(aButton: ToggleButton):
    if aButton != selected_button:
        aButton.modulate = modulateColorNormal

func _on_button_pressed(aButton: ToggleButton):
    aButton.modulate = modulateColorPressed
    if (selected_button != null):
        selected_button.un_select()
        selected_button.modulate = modulateColorNormal
    selected_button = aButton
    _item_selected()

func _item_selected():
    # overrideable function
    pass

func _item_deselected():
    # overrideable function
    pass
