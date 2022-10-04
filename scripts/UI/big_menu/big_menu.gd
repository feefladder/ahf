extends TabMenu
class_name BigMenu

export(NodePath) var item_container_path = NodePath("ItemContainer")
export(NodePath) var display_path = NodePath("/root/Loader/Background/Livestock")

export(String) var title
export(String) var resource_name
onready var item_container = get_node_or_null(item_container_path)
onready var display = get_node_or_null(display_path)

func _ready():
    if get_node_or_null("Title"):
        $Title.text = title
    if item_container:
        item_container.resource_name = resource_name

func _on_int_item_increased(which: IntResource) -> void:
    print(which.resource_name)
    if display:
        if display.has_method("increase_int_item"):
            display.increase_int_item(which)

func _on_int_item_decreased(which: IntResource) -> void:
    print(which.resource_name)
    if display:
        if display.has_method("decrease_int_item"):
            display.decrease_int_item(which)

func _on_toggle_item_set(which: ToggleResource, to_what: bool) -> void:
    print("set ", which.resource_name, " to ", to_what)


func next_year():
    pass # Replace with function body.
