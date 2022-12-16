extends Node
class_name FamilyDisplay

export(NodePath) var db_path = NodePath("/root/Database")

var family_dict: Dictionary = {}
var labourers_array: Array = []
onready var database = get_node_or_null(db_path)

func update_to_db():
    update_family_to_db()

    var labourers: Array = database.get_generic_amount(database.LABOUR_TABLE, "labourer")
    assert(labourers.size() == 1)
    if labourers[0]["amount"] == labourers_array.size():
        return
    var d_l: int = labourers[0]["amount"]-labourers_array.size()
    if d_l > 0:
        for _i in range(d_l):
            labourers_array.append(add_person(labourers[0]["resource"]))
    else:
        for _i in range(-d_l):
            labourers_array.pop_back().queue_free()
    assert(labourers_array.size() == labourers[0]["amount"])

func update_family_to_db():
    var family: Array = database.get_family()
    for member in family:
        var id: int = member["id"]
        if not id in family_dict:
            family_dict[id] = member #since dicts are copied 
            family_dict[id]["sprite"] = add_person(member["resource"])
        else:
            family_dict[id]["on_farm"] = member["on_farm"]

        if family_dict[id]["on_farm"]:
            family_dict[id]["sprite"].show()
        else:
            family_dict[id]["sprite"].hide()

func add_person(person: Resource) -> Sprite:
    var sprite = Sprite.new()
    sprite.texture = person.image
    var scale = 0.5
    sprite.scale = Vector2(scale, scale)
    var nr_people = family_dict.size()+labourers_array.size()
    sprite.position += sprite.scale*Vector2(50.0*nr_people,-sprite.texture.get_size().y /2)
    add_child(sprite)
    return sprite

# func add_labourer(labourer: IntResource) -> void:
#     labourers_array.append(add_person(labourer))

# func remove_labourer() -> void:
#     labourers_array.pop_back().queue_free()
