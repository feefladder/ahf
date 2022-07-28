extends ToggleButtonContainer
class_name BuyMenuItemContainer

export(PackedScene) var BuyMenuItemScene = preload("res://scenes/UI/buy_menu/buy_menu_item.tscn")

export(NodePath) var path_to_ResourceLoader = "/root/ResourceLoader"
export(String) var my_resource_name

# Called when the node enters the scene tree for the first time.
func _ready():
    assert(get_node(path_to_ResourceLoader).connect("resources_loaded",self,"_on_ResourceLoader_resources_loaded") == 0)

func add_MenuItem(a_resource: BuyResource):
    var menu_item = BuyMenuItemScene.instance()
    menu_item.title = a_resource.resource_name
    menu_item.icon = a_resource.image
    menu_item.resource = a_resource
#    menu_item.connect("pressed",get_node(path_to_StateController),"_on_BuyMenuItem_clicked")
    add_child(menu_item)

func _on_ResourceLoader_resources_loaded(which: String, resources: Array) -> void:
    if which == my_resource_name:
        for resource in resources:
            add_MenuItem(resource)
        _connect_children()
