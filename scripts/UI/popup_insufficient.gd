extends Panel
class_name PopupInsufficient


export(NodePath) var label_path

func pop_up_insufficient(insufficients: Dictionary) -> void:
    var types = "you don't have enough "
    var amounts = "need "
    for key in insufficients:
        types += String(key) + ", "
        amounts += String(insufficients[key]) + " more " + String(key) + ", "
    get_node(label_path).text = types + amounts + "so sad!"
    self.show()
