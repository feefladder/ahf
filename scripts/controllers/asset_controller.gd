extends HBoxContainer
class_name AssetController

signal asset_changed(which, new_amount)

export(int) var start_money

export(NodePath) var database_path = NodePath("/root/Database")
export(NodePath) var popup_insufficient_path
export(NodePath) var popup_max_reached_path

var available_labour := 0.0
var used_labour := 0.0
var available_money := 0.0
var used_money := 0.0

onready var popup_insufficient = get_node(popup_insufficient_path)
onready var popup_max_reached = get_node(popup_max_reached_path)
onready var database = get_node(database_path)

func _ready():
    available_money = start_money
    database.connect("all_resources_loaded",self,"_on_all_resources_loaded")
    add_to_group("controllers")

func _on_all_resources_loaded():
    database.add_generic_item("money",database.ASSET_TABLE, available_money)
    
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

    database.buy_sell_item(
        item.resource_name,
        database.BUY_SELL_TABLE, 
        1
    )

    used_money += item.unit_price
    used_labour += item.unit_labour
    emit_signal("asset_changed","money", available_money-used_money)
    emit_signal("asset_changed","labour", available_labour-used_labour)
    return true

func sell_item(item: BuyResource) -> bool:
    if not has_enough(-item.unit_price, -item.unit_labour):
        return false
    
    database.buy_sell_item(
        item.resource_name,
        database.BUY_SELL_TABLE,
        -1
    )

    used_money -= item.unit_price
    used_labour -= item.unit_labour
    emit_signal("asset_changed","money", available_money-used_money)
    emit_signal("asset_changed","labour", available_labour-used_labour)
    return true

func start_year():
    available_money = database.get_generic_amount("money", database.ASSET_TABLE)
    print_debug(available_money)
    used_money = 0.0
    used_labour = 0.0 # TODO: <- not true
    emit_signal("asset_changed","money", available_money-used_money)
    emit_signal("asset_changed","labour", available_labour-used_labour)
    # money = database.get_generic_amount("money", database.ASSET_TABLE)
