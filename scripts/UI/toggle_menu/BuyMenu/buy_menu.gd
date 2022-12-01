extends TabMenu
class_name BuyMenu

export(String) var title
export(PoolStringArray) var fields_names

export(NodePath) var buy_menu_item_container_path = NodePath("CropsBuyMenu/ScrollContainer/BuyMenuItemContainer")

onready var buy_menu_item_container = get_node(buy_menu_item_container_path)

func _ready():
    buy_menu_item_container.my_resource_names = fields_names
