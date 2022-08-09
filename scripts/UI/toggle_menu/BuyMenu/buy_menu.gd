extends TabMenu
class_name BuyMenu

export(String) var title
export(String) var resource_name

export(NodePath) var buy_menu_item_container_path = "CropsBuyMenu/ScrollContainer/BuyMenuItemContainer"

onready var buy_menu_item_container = get_node(buy_menu_item_container_path)

func _ready():
    buy_menu_item_container.my_resource_name = resource_name
