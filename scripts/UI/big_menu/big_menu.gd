extends TabMenu
class_name BigMenu

export(NodePath) var item_container_path = NodePath("ItemContainer")
export(NodePath) var display_path = NodePath("/root/Database/Background/Livestock")
export(NodePath) var database_path = NodePath("/root/Database")
export(NodePath) var asset_manager_path = NodePath("/root/Database/AssetManager")

export(String) var title
export(PoolStringArray) var resource_names
onready var item_container = get_node_or_null(item_container_path)
onready var display = get_node_or_null(display_path)
onready var database = get_node_or_null(database_path)
onready var asset_manager = get_node_or_null(asset_manager_path)

func _ready():
    # warning-ignore:return_value_discarded
    database.connect("resources_loaded", self, "_on_Database_resources_loaded")
    if get_node_or_null("Title"):
        $Title.text = title

func _on_int_item_increased(which: IntResource) -> void:
    # TODO: call db and do things
    if display:
        if display.has_method("increase_int_item"):
            display.increase_int_item(which)

func _on_int_item_decreased(which: IntResource) -> void:
    # TODO: call db and do things
    if display:
        if display.has_method("decrease_int_item"):
            display.decrease_int_item(which)

func _on_toggle_item_set(which: BuyResource, to_what: bool) -> void:
    print("set ", which.resource_name, " to ", to_what)


func _on_Database_resources_loaded(which, resources):
    if which in resource_names:
        for resource in resources:
            if resource is IntResource:
                item_container.add_menu_int_item(resource)
            elif resource is BuyResource:
                item_container.add_menu_toggle_item(resource)
            else:
                print("Resource: ", resource.resource_name, "not used")

        _use_resources(resources)

func try_increase_resource(an_item: IntResource) -> int:
    return -1

func try_decrease_resource(an_item: IntResource) -> int:
    return -1

func try_toggle_item(item: BuyResource) -> bool:
    return false

func next_year():
    pass # Replace with function body.

func _use_resources(_resources: Array):
    pass # to be overridden
