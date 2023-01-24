extends ToggleButtonContainer
class_name BuyMenuItemContainer

export(PackedScene) var BuyMenuItemScene = preload("res://scenes/UI/buy_menu/buy_menu_item.tscn")

export(NodePath) var controller_path = NodePath("../../../")

onready var controller = get_node(controller_path)

func add_items(resources: Array) -> void:
    for resource in resources:
        add_MenuItem(resource)

func add_MenuItem(a_resource: BuyResource) -> void:
    var menu_item = BuyMenuItemScene.instance()
    menu_item.resource = a_resource
    menu_item.controller = controller
    add_child(menu_item)
