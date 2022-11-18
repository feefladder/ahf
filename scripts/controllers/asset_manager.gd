extends HBoxContainer
class_name AssetManager

signal asset_changed(which, new_amount)

export(float) var money
export(float) var labour

export(NodePath) var resource_loader_path = NodePath("/root/Database")
export(NodePath) var popup_insufficient_path
export(NodePath) var popup_max_reached_path

var acquired_assets: Dictionary
var persistent_assets: Dictionary

onready var popup_insufficient = get_node(popup_insufficient_path)
onready var popup_max_reached = get_node(popup_max_reached_path)

# Called when the node enters the scene tree for the first time.
func _ready():
    emit_signal("asset_changed","money", money)
    emit_signal("asset_changed","labour", labour)

func try_buy_item(an_item: IntResource) -> bool:
    if an_item.current_number >= an_item.max_number:
        popup_max_reached.pop_up(an_item)
        return false
    if not decrease_assets(an_item.unit_price, an_item.unit_labour):
        return false

    an_item.current_number += 1

    if an_item in acquired_assets:
        acquired_assets[an_item] += 1
    else:
        acquired_assets[an_item] = 1

    emit_signal("asset_changed", an_item, an_item.current_number)

    return true

func try_sell_item(an_item: IntResource) -> bool:
    if an_item.current_number <= 0: #cannot be <0, but just in case
        return false

    if not increase_assets(an_item.unit_price, an_item.unit_labour):
        return false

    if an_item in acquired_assets:
        acquired_assets[an_item] -= 1
    else:
        acquired_assets[an_item] = -1

    if acquired_assets[an_item] == 0:
        if not acquired_assets.erase(an_item):
            printerr("erasing from acquired_assets failed")

    an_item.current_number -= 1
    emit_signal("asset_changed", an_item, an_item.current_number)

    return true

func try_toggle_item(an_item: ToggleResource) -> bool:
    if an_item.implemented:
        # remove it
        if not increase_assets(an_item.unit_price, an_item.unit_labour):
            return false


        an_item.implemented = false
        if an_item in acquired_assets:
            print("removed item: ", an_item.resource_name)
            if not acquired_assets.erase(an_item):
                printerr("removing from acquired_assets failed!")
        else:
            #meaning we sell it (like a house or a car)
            acquired_assets[an_item] = -1
        emit_signal("asset_changed", an_item, an_item.implemented)
        return true
    else:
        # we don't have it yet
        if not decrease_assets(an_item.unit_price, an_item.unit_labour):
            return false

        an_item.implemented = true
        # can afford -> buy it
        acquired_assets[an_item] = 1
        emit_signal("asset_changed", an_item, an_item.implemented)
        return true

func has_enough(req_money: float, req_labour: float) -> bool:
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

func decrease_assets(dec_money: float, dec_labour: float) -> bool:
    if not has_enough(dec_money, dec_labour):
        return false

    money -= dec_money
    labour -= dec_labour
    emit_signal("asset_changed", "money", money)
    emit_signal("asset_changed","labour", labour)
    return true


func increase_assets(inc_money: float, inc_labour: float) -> bool:
    if not has_enough(-inc_money, -inc_labour):
        return false

    money += inc_money
    labour += inc_labour
    emit_signal("asset_changed", "money", money)
    emit_signal("asset_changed","labour", labour)
    return true

func make_summary() -> AssetSummaryResource:
    return $AssetCalculator.make_summary()
