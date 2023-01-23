extends TabMenu
class_name BigMenu

export(NodePath) var item_container_path = NodePath("ItemContainer")
export(NodePath) var display_path = NodePath("/root/Database/Background/Livestock")
export(NodePath) var database_path = NodePath("/root/Database")
export(NodePath) var asset_controller_path = NodePath("/root/Database/AssetController")

export(String) var title
export(PoolStringArray) var resource_names
onready var item_container = get_node_or_null(item_container_path)
onready var display = get_node_or_null(display_path)
onready var database = get_node_or_null(database_path)
onready var asset_controller = get_node_or_null(asset_controller_path)

func _ready():
    add_to_group("controllers")
    # warning-ignore:return_value_discarded
    database.connect("resources_loaded", self, "_on_Database_resources_loaded")
    if get_node_or_null("Title"):
        $Title.text = title

func _on_Database_resources_loaded(which: String, resources: Array):
    if which in resource_names:
        for resource in resources:
            if resource is IntResource:
                item_container.add_menu_int_item(resource)
            elif resource is BuyResource:
                item_container.add_menu_toggle_item(resource)
            else:
                print_debug("Resource: ", resource.resource_name, "not used")

        _use_resources(resources)

func try_increase_resource(_an_item: IntResource) -> int:
    print_debug("unoverridden try_increase_resource!")
    return -1

func try_decrease_resource(_an_item: IntResource) -> int:
    print_debug("unoverridden try_decrease_resource!")
    return -1

func try_toggle_item(_an_item: BuyResource) -> bool:
    print_debug("unoverridden try_toggle_item!")
    return false

func end_of_year():
    print_debug("unoverridden end_of_year called in ",self)

func _use_resources(_resources: Array):
    pass # to be overridden
