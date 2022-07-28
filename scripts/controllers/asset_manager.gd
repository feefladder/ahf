extends HBoxContainer
class_name AssetManager

#signal asset_changed(new_amount, asset_type)
#signal money_changed(new_amount)
#signal labour_changed(new_amount)

export(float) var money
export(float) var labour
export(Array, Resource) var available_animals

export(NodePath) var resource_loader_path = "/root/ResourceLoader"
export(NodePath) var popup_insufficient_path
export(NodePath) var popup_max_reached_path

export(Dictionary) var stat_trackers

var acquired_assets: Dictionary

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
            return true

    if decrease_assets(an_item.unit_price, an_item.unit_labour):
        # we can buy the item: add it to the acquired_assets:
        if an_item in acquired_assets:
            acquired_assets[an_item] += 1
        else:
            acquired_assets[an_item] = 1
        if an_item in stat_trackers:
            get_node(stat_trackers[an_item]).set_number(acquired_assets[an_item])
        return false
    else:
        return true

func try_sell_item(an_item: IntResource) -> bool:
    if not an_item in acquired_assets:
        return true
    if acquired_assets[an_item] > 0:
        increase_assets(an_item.unit_price, an_item.unit_labour)
        acquired_assets[an_item] -= 1
        
        # update the display
        if an_item in stat_trackers:
            get_node(stat_trackers[an_item]).set_number(acquired_assets[an_item])
        if acquired_assets[an_item] == 0:
            assert( acquired_assets.erase(an_item) == true)
        return false
    else:
        return true

func toggle_item(an_item: BuyResource) -> bool:
    if an_item in acquired_assets:
        # remove it
        increase_assets(an_item.unit_price, an_item.unit_labour)
        assert( acquired_assets.erase(an_item) == true)
        return false
    else:
        # we don't have it yet
        if decrease_assets(an_item.unit_price, an_item.unit_labour):
            # can afford -> buy it
            acquired_assets[an_item] = true
            return false
        else:
            # cannot afford -> don't buy
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
    if has_enough(dec_money, dec_labour):
        money -= dec_money
        labour -= dec_labour
        get_node(stat_trackers["money"])._on_stat_changed(money)
        get_node(stat_trackers["labour"])._on_stat_changed(labour)
        return true
    else:
        return false

func increase_assets(inc_money: float, inc_labour: float) -> void:
    money += inc_money
    labour += inc_labour
    get_node(stat_trackers["money"])._on_stat_changed(money)
    get_node(stat_trackers["labour"])._on_stat_changed(labour)

func make_summary() -> AssetSummaryResource:
    var summary = AssetSummaryResource.new()
    
    return summary
