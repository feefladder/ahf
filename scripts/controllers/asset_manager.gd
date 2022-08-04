extends HBoxContainer
class_name AssetManager

export(float) var money
export(float) var labour

export(NodePath) var resource_loader_path = "/root/Loader"
export(NodePath) var popup_insufficient_path
export(NodePath) var popup_max_reached_path

export(Dictionary) var stat_trackers

var acquired_assets: Dictionary
var persistent_assets: Dictionary

onready var popup_insufficient = get_node(popup_insufficient_path)
onready var popup_max_reached = get_node(popup_max_reached_path)

# Called when the node enters the scene tree for the first time.
func _ready():
    get_node(stat_trackers["money"])._on_stat_changed(money)
    get_node(stat_trackers["labour"])._on_stat_changed(labour)

func try_buy_item(an_item: IntResource) -> bool:
    if an_item in acquired_assets:
       if acquired_assets[an_item] >= an_item.max_number:
            popup_max_reached.pop_up(an_item)
            return false
    if decrease_assets(an_item.unit_price, an_item.unit_labour):
        # we can buy the item: add it to the acquired_assets:
        if an_item in acquired_assets:
            acquired_assets[an_item] += 1
        else:
            acquired_assets[an_item] = 1
        if an_item in stat_trackers:
            get_node(stat_trackers[an_item]).set_number(acquired_assets[an_item])
        return true
    else:
        return false

func try_sell_item(an_item: IntResource) -> bool:
    if not an_item in acquired_assets:
        return false

    if acquired_assets[an_item] > 0:
        if not increase_assets(an_item.unit_price, an_item.unit_labour):
            return false
        #successfully sold item!
        acquired_assets[an_item] -= 1
        # update the display
        if an_item in stat_trackers:
            get_node(stat_trackers[an_item]).set_number(acquired_assets[an_item])
        if acquired_assets[an_item] == 0:
            assert( acquired_assets.erase(an_item) == true)
        return true
    else:
        return false

func try_toggle_item(an_item: ToggleResource) -> bool:
    if an_item in acquired_assets:
        # remove it
        if increase_assets(an_item.unit_price, an_item.unit_labour):
            assert(acquired_assets.erase(an_item) == true)
            print("removed item: ", an_item.resource_name)
            return true
        else:
            return false
    else:
        # we don't have it yet
        if decrease_assets(an_item.unit_price, an_item.unit_labour):
            # can afford -> buy it
            acquired_assets[an_item] = true
            print("added item: ", an_item.resource_name)
            return true
        else:
            # cannot afford -> don't buy
            return false

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
    get_node(stat_trackers["money"])._on_stat_changed(money)
    get_node(stat_trackers["labour"])._on_stat_changed(labour)
    return true


func increase_assets(inc_money: float, inc_labour: float) -> bool:
    if not has_enough(-inc_money, -inc_labour):
        return false

    money += inc_money
    labour += inc_labour
    get_node(stat_trackers["money"])._on_stat_changed(money)
    get_node(stat_trackers["labour"])._on_stat_changed(labour)
    return true

func make_summary() -> AssetSummaryResource:
    return $AssetCalculator.make_summary()
