extends HBoxContainer
class_name AssetManager

#signal asset_changed(new_amount, asset_type)
signal money_changed(new_amount)
signal labour_changed(new_amount)

export(NodePath) var popup_insufficient_path
export(float) var money
export(float) var labour
export(Array, Resource) var available_animals

export(NodePath) var resource_loader_path = "/root/ResourceLoader"

var popup_insufficient: PopupInsufficient

# Called when the node enters the scene tree for the first time.
func _ready():
    popup_insufficient = get_node(popup_insufficient_path)
    emit_signal("money_changed", money)

func decrease_assets(dec_money: float, dec_labour: float) -> bool:
    if (money >= dec_money and labour >= dec_labour):
        money -= dec_money
        labour -= dec_labour
        emit_signal("money_changed", money)
        emit_signal("labour_changed", labour)
        return false
    else:
        var insufficients = {}
        
        if money < dec_money:
            insufficients["money"] = dec_money - money
        if labour < dec_labour:
            insufficients["labour"] = dec_labour - labour
            
        popup_insufficient.pop_up_insufficient(insufficients)
        return true

func increase_assets(inc_money: float, inc_labour: float) -> void:
    money += inc_money
    labour += inc_labour
    emit_signal("money_changed", money)
    emit_signal("labour_changed", labour)
