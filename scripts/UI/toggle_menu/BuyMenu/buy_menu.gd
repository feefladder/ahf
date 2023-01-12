extends TabMenu
class_name BuyMenu

export(String) var title
export(PoolStringArray) var resources_names

# export(NodePath) var buy_menu_item_container_path = NodePath("CropsBuyMenu/ScrollContainer/BuyMenuItemContainer")
export(NodePath) var database_path = NodePath("/root/Database")

onready var database = get_node(database_path)
onready var buy_menu_item_container = get_node("VBoxContainer/ScrollContainer/BuyMenuItemContainer")

func _ready():
    add_to_group("controllers")
    database.connect("resources_loaded", self, "_on_Database_resources_loaded")
    database.connect("all_resources_loaded", self, "_on_Database_all_resources_loaded")
    $VBoxContainer/Title.text = tr(title)

func _on_Database_resources_loaded(which: String, resources: Array):
    if which in resources_names:
        buy_menu_item_container.add_items(resources)
    _use_resources(resources)

func _use_resources(_resources: Array) -> void:
    #override in child
    pass

func _on_Database_all_resources_loaded():
    #TODO: this is ugly...
    buy_menu_item_container._connect_children()

func next_year():
    print_debug("unoverridden next_year called in ",self)

func start_year():
    print_debug("unoverridden start_year called in ",self)
