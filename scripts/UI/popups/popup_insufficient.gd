extends Control
class_name PopupInsufficient

export(NodePath) var label_path

func pop_up_insufficient(insufficients: Dictionary) -> void:
    var types = "you don't have enough "
    var amounts = "need "
    for key in insufficients:
        types += String(key) + ", "
        amounts += String(insufficients[key]) + " more " + String(key) + ", "
    amounts.erase(amounts.length() - 2, 2)
    get_node(label_path).text = types + amounts
    self.show()
