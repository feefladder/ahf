extends Node
class_name BigMenuItemContainer

export(NodePath) var resource_loader_path = NodePath("/root/Database")
export(NodePath) var asset_manager_path = NodePath("/root/Database/AssetManager")
export(NodePath) var manager_path = NodePath("../")

export(PackedScene) var big_menu_int_item_scene = load("res://scenes/UI/big_menu/big_menu_int_item.tscn")
export(PackedScene) var big_menu_toggle_item_scene = load("res://scenes/UI/big_menu/big_menu_toggle_item.tscn")
export(String) var resource_name = null

onready var manager = get_node_or_null(manager_path)

func add_menu_toggle_item(resource: BuyResource) -> void:
    var menu_item: HBoxContainer = big_menu_toggle_item_scene.instance()
    menu_item.resource = resource
    # warning-ignore:return_value_discarded
    menu_item.connect("item_pressed", self, "_try_toggle_button")
    add_child(menu_item)

func add_menu_int_item(resource: IntResource) -> void:
    var menu_item: HBoxContainer = big_menu_int_item_scene.instance()
    menu_item.resource = resource
    # warning-ignore:return_value_discarded
    menu_item.connect("increase_pressed", self, "_try_increase_resource")
    # warning-ignore:return_value_discarded
    menu_item.connect("decrease_pressed", self, "_try_decrease_resource")
    add_child(menu_item)

func _try_toggle_button(menu_item: BigMenuToggleItem, is_pressed: bool) -> void:
    if manager.try_toggle_item(menu_item.resource):
        pass
#        emit_signal("toggle_item_set", menu_item.resource, is_pressed)
    else:
        menu_item.set_toggle(not is_pressed)


func _try_increase_resource(menu_item: BigMenuIntItem) -> void:
    var new_number = manager.try_increase_resource(menu_item.resource)
    if new_number != -1:
        menu_item.change_number(new_number)

func _try_decrease_resource(menu_item: BigMenuIntItem) -> void:
    var new_number = manager.try_decrease_resource(menu_item.resource)
    if new_number != -1:
        menu_item.change_number(new_number)
