extends Node
class_name BigMenuItemContainer

signal increased_int_item(which)
signal decreased_int_item(which)
signal toggle_item_set(which, state)

export(NodePath) var resource_loader_path = NodePath("/root/Loader")
export(NodePath) var asset_manager_path = NodePath("/root/Loader/AssetManager")
export(NodePath) var manager_path = NodePath("../")
export(NodePath) var display_path = NodePath("/root/Loader/Family")

export(PackedScene) var big_menu_int_item_scene = load("res://scenes/UI/big_menu/big_menu_int_item.tscn")
export(PackedScene) var big_menu_toggle_item_scene = load("res://scenes/UI/big_menu/big_menu_toggle_item.tscn")
export(String) var resource_name = null

onready var asset_manager: AssetManager = get_node(asset_manager_path)
onready var manager = get_node_or_null(manager_path)

# Called when the node enters the scene tree for the first time.
func _ready():
    if get_node(resource_loader_path).connect("resources_loaded", self, "_on_Loader_resources_loaded"):
        print_debug("connect failed!")
    if connect("increased_int_item", manager, "_on_int_item_increased"):
        print_debug("connect failed!")
    if connect("decreased_int_item", manager, "_on_int_item_decreased"):
        print_debug("connect failed!")
    if connect("toggle_item_set", manager, "_on_toggle_item_set"):
        print_debug("connect failed!")
    asset_manager = get_node(asset_manager_path)

func _on_Loader_resources_loaded(which, resources):
    if which == resource_name:
        for resource in resources:
            if resource is IntResource:
                add_menu_int_item(resource)
            elif resource is ToggleResource:
                add_menu_toggle_item(resource)
            else:
                print("Resource: ", resource.resource_name, "not used")

            if manager.has_method("use_resource"):
                manager.use_resource(resource)

func add_menu_toggle_item(resource: ToggleResource) -> void:
    var menu_item: HBoxContainer = big_menu_toggle_item_scene.instance()
    menu_item.resource = resource
    if menu_item.connect("item_pressed", self, "_try_toggle_button"):
        print_debug("connect failed!")
    add_child(menu_item)

func add_menu_int_item(resource: IntResource):
    var menu_item: HBoxContainer = big_menu_int_item_scene.instance()
    menu_item.resource = resource
    if menu_item.connect("increase_pressed", self, "_try_increase_resource"):
        print_debug("connect failed!")
    if menu_item.connect("decrease_pressed", self, "_try_decrease_resource"):
        print_debug("connect failed!")
    add_child(menu_item)

func _try_toggle_button(menu_item: BigMenuToggleItem, is_pressed: bool):
    if asset_manager.try_toggle_item(menu_item.resource):
        emit_signal("toggle_item_set", menu_item.resource, is_pressed)
    else:
        menu_item.set_toggle(not is_pressed)


func _try_increase_resource(menu_item: BigMenuIntItem):
    if asset_manager.try_buy_item(menu_item.resource):
            menu_item.change_number(menu_item.resource.current_number)
            emit_signal("increased_int_item", menu_item.resource)

func _try_decrease_resource(menu_item: BigMenuIntItem):
    if asset_manager.try_sell_item(menu_item.resource):
        menu_item.change_number(menu_item.resource.current_number)
        emit_signal("decreased_int_item", menu_item.resource)
