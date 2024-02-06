extends Node
class_name StateController

export(NodePath) var crop_handler_path = NodePath("CropHandler")

onready var crop_handler = get_node(crop_handler_path)

var current_node: TabMenu

func _on_tab_changed(a_tab):
	if current_node:
		current_node.deactivate()
	if not a_tab:
		return

	current_node = a_tab.get_node(a_tab.target)
	current_node.activate()

func _on_fieldblock_pressed(a_block):
	if current_node:
		if current_node.has_method("fieldblock_pressed"):
			current_node.fieldblock_pressed(a_block)

func _on_fieldblock_unpressed(a_block):
	if current_node:
		if current_node.has_method("fieldblock_unpressed"):
			current_node.fieldblock_unpressed(a_block)
