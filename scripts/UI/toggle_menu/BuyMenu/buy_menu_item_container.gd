extends ToggleButtonContainer
class_name BuyMenuItemContainer

export(PackedScene) var BuyMenuItemScene = preload("res://scenes/UI/buy_menu/buy_menu_item.tscn")

export(NodePath) var path_to_Loader = NodePath("/root/Loader")
export(String) var my_resource_name

export(NodePath) var asset_manager_path = NodePath("/root/Loader/AssetManager")
export(NodePath) var controller_path = NodePath("../../../")
onready var asset_manager = get_node(asset_manager_path)
onready var controller = get_node(controller_path)

# Called when the node enters the scene tree for the first time.
func _ready():
    printerr(get_node(path_to_Loader).connect("resources_loaded",self,"_on_Loader_resources_loaded"))

func add_MenuItem(a_resource: BuyResource):
    var menu_item = BuyMenuItemScene.instance()
    menu_item.resource = a_resource
    menu_item.controller = controller
    add_child(menu_item)

func _on_Loader_resources_loaded(which: String, resources: Array) -> void:
    if which == my_resource_name:
        for resource in resources:
            add_MenuItem(resource)
        _connect_children()
