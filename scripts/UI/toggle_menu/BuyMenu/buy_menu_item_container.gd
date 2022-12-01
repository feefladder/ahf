extends ToggleButtonContainer
class_name BuyMenuItemContainer

export(PackedScene) var BuyMenuItemScene = preload("res://scenes/UI/buy_menu/buy_menu_item.tscn")

export(NodePath) var path_to_Database = NodePath("/root/Database")
export(PoolStringArray) var my_resource_names

export(NodePath) var asset_manager_path = NodePath("/root/Database/AssetManager")
export(NodePath) var controller_path = NodePath("../../../")
onready var asset_manager = get_node(asset_manager_path)
onready var controller = get_node(controller_path)

# Called when the node enters the scene tree for the first time.
func _ready():
    if get_node(path_to_Database).connect("resources_loaded",self,"_on_Database_resources_loaded"):
        print_debug("connect failed!")

func add_MenuItem(a_resource: BuyResource):
    var menu_item = BuyMenuItemScene.instance()
    menu_item.resource = a_resource
    menu_item.controller = controller
    add_child(menu_item)

func _on_Database_resources_loaded(which: String, resources: Array) -> void:
    if which in my_resource_names:
        for resource in resources:
            add_MenuItem(resource)
        _connect_children()
