extends HBoxContainer
class_name AssetManager

signal asset_changed(which, new_amount)

export(int) var available_money

export(NodePath) var database_path = NodePath("/root/Database")
export(NodePath) var popup_insufficient_path
export(NodePath) var popup_max_reached_path

var available_labour: int =0
var used_labour: int = 0
var used_money: int =0

onready var popup_insufficient = get_node(popup_insufficient_path)
onready var popup_max_reached = get_node(popup_max_reached_path)
onready var database = get_node(database_path)

func _ready():
    database.connect("all_resources_loaded",self,"_on_all_resources_loaded")

func _on_all_resources_loaded():
    database.add_generic_item("money",database.ASSET_TABLE,available_money)
    database.add_generic_item("used_labour",database.ASSET_TABLE,0)
    _on_people_changed()

func _on_people_changed():
    available_labour = database.get_total_available_labour()
    # used labour should be 0
    emit_signal("asset_changed","labour", available_labour-used_labour)

func has_enough(req_money: float, req_labour: float) -> bool:
    var labour = available_labour-used_labour
    var money = available_money - used_money
    if (money < req_money or labour < req_labour):
        var insufficients = {}

        if money < req_money:
            insufficients["money"] = req_money - money
        if labour < req_labour:
            insufficients["labour"] = req_labour - labour

        popup_insufficient.pop_up_insufficient(insufficients)
        return false
    else:
        return true

func buy_item(item: BuyResource) -> bool:
    if not has_enough(item.unit_price, item.unit_labour):
        return false

    used_money += item.unit_price
    used_labour += item.unit_labour
    emit_signal("asset_changed","money", available_money-used_money)
    emit_signal("asset_changed","labour", available_labour-used_labour)
    return true

func sell_item(item: BuyResource) -> bool:
    if not has_enough(-item.unit_price, -item.unit_labour):
        return false
    
    used_money -= item.unit_price
    used_labour -= item.unit_labour
    emit_signal("asset_changed","money", available_money-used_money)
    emit_signal("asset_changed","labour", available_labour-used_labour)
    return true


# func decrease_assets(dec_money: float, dec_labour: float) -> bool:
#     if not has_enough(dec_money, dec_labour):
#         return false

#     money = database.change_generic_item("money", database.ASSET_TABLE, -dec_money)
#     used_labour = database.change_generic_item("used_labour", database.ASSET_TABLE, dec_labour)
#     emit_signal("asset_changed", "money", money)
#     emit_signal("asset_changed","labour", available_labour-used_labour)
#     return true


# func increase_assets(inc_money: float, inc_labour: float) -> bool:
#     if not has_enough(-inc_money, -inc_labour):
#         return false

#     money = database.change_generic_item("money", database.ASSET_TABLE, inc_money)
#     used_labour = database.change_generic_item("used_labour", database.ASSET_TABLE, -inc_labour)
#     emit_signal("asset_changed", "money", money)
#     emit_signal("asset_changed","labour", available_labour-used_labour)
#     return true

# func make_summary() -> AssetSummaryResource:
#     return $AssetCalculator.make_summary()

func start_year():
    print_debug("year started, yay!")
    # money = database.get_generic_amount("money", database.ASSET_TABLE)
