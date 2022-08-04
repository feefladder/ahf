extends Node

signal increased_int_item(which)
signal decreased_int_item(which)
signal toggle_item_set(which, state)

export(NodePath) var resource_loader_path = "/root/Loader"
export(NodePath) var asset_manager_path = "/root/Loader/AssetManager"
export(NodePath) var manager_path = "/root/Loader/AnimalsMenu"
export(NodePath) var display_path = "/root/Loader/Family"

export(PackedScene) var big_menu_int_item_scene = load("res://scenes/UI/big_menu/big_menu_int_item.tscn")
export(PackedScene) var big_menu_toggle_item_scene = load("res://scenes/UI/big_menu/big_menu_toggle_item.tscn")
export(String) var my_int_resource_name = null

onready var asset_manager: AssetManager = get_node(asset_manager_path)
onready var manager = get_node_or_null(manager_path)

# Called when the node enters the scene tree for the first time.
func _ready():
    assert(get_node(resource_loader_path).connect("resources_loaded", self, "_on_Loader_resources_loaded") == 0)
#    assert(connect("increased_int_item", manager, "_on_increased_int_item") == 0)
#    assert(connect("decreased_int_item", manager, "_on_decreased_int_item") == 0)
    asset_manager = get_node(asset_manager_path)

func _on_Loader_resources_loaded(which, resources):
    if which == my_int_resource_name:
        for resource in resources:
            if resource is IntResource:
                add_menu_int_item(resource)
            elif resource is ToggleResource:
                add_menu_toggle_item(resource)

func add_menu_toggle_item(resource: ToggleResource) -> void:
    var menu_item: HBoxContainer = big_menu_toggle_item_scene.instance()
    menu_item.resource = resource
    assert(menu_item.connect("item_pressed", self, "_try_toggle_button") == 0)
    add_child(menu_item)

func add_menu_int_item(resource: IntResource):
    var menu_item: HBoxContainer = big_menu_int_item_scene.instance()
    menu_item.resource = resource
    assert(menu_item.connect("increase_pressed", self, "_try_increase_resource") == 0)
    assert(menu_item.connect("decrease_pressed", self, "_try_decrease_resource") == 0)
    add_child(menu_item)

func _try_toggle_button(menu_item: BigMenuToggleItem, is_pressed: bool):
    print(menu_item, is_pressed)
    if asset_manager.try_toggle_item(menu_item.resource):
        emit_signal("toggle_item_set", menu_item, is_pressed)
    else:
        menu_item.set_toggle(not is_pressed)


func _try_increase_resource(menu_item: BigMenuIntItem):
    if asset_manager.try_buy_item(menu_item.resource):
#    if menu_item.resource.current_number < menu_item.resource.max_number:
#        if not asset_manager.decrease_assets(menu_item.resource.unit_price, menu_item.resource.unit_labour):
            menu_item.change_number(menu_item.resource.current_number + 1)
            emit_signal("increased_int_item", menu_item.resource)

func _try_decrease_resource(menu_item: BigMenuIntItem):
    if asset_manager.try_sell_item(menu_item.resource):
#    if menu_item.resource.current_number > 0:
#        asset_manager.increase_assets(menu_item.resource.unit_price, menu_item.resource.unit_labour)
        menu_item.change_number(menu_item.resource.current_number -1)
        emit_signal("decreased_int_item", menu_item.resource)
