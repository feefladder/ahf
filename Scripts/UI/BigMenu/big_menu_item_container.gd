extends Node

signal increased_resource(which)
signal decreased_resource(which)

export(NodePath) var resource_loader_path = "/root/ResourceLoader"
export(NodePath) var asset_manager_path = "/root/ResourceLoader/StateController/AssetManager"
export(PackedScene) var big_menu_int_item_scene
export(String) var my_int_resource_name = null

var asset_manager: AssetManager

# Called when the node enters the scene tree for the first time.
func _ready():
    get_node(resource_loader_path).connect("resources_loaded", self, "_on_ResourceLoader_resources_loaded")
    asset_manager = get_node(asset_manager_path)

func _on_ResourceLoader_resources_loaded(which, resources):
    if which == my_int_resource_name:
        for resource in resources:
            add_menu_int_item(resource)

func add_menu_int_item(resource: BuyResource):
    var menu_item: HBoxContainer = big_menu_int_item_scene.instance()
    menu_item.resource = resource
    menu_item.connect("increase_pressed", self, "_try_increase_resource")
    menu_item.connect("decrease_pressed", self, "_try_decrease_resource")
    add_child(menu_item)

func _try_increase_resource(menu_item: BigMenuIntItem):
    if menu_item.resource.current_number < menu_item.resource.max_number:
        if not asset_manager.decrease_assets(menu_item.resource.unit_price, menu_item.resource.unit_labour):
            menu_item.change_number(menu_item.resource.current_number + 1)
            emit_signal("increased_resource", menu_item.resource)

func _try_decrease_resource(menu_item: BigMenuIntItem):
    if menu_item.resource.current_number > 0:
        asset_manager.increase_assets(menu_item.resource.unit_price, menu_item.resource.unit_labour)
        menu_item.change_number(menu_item.resource.current_number -1)
        emit_signal("decreased_resource", menu_item.resource)
