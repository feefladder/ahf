extends DisplayBase
class_name FamilyDisplay

export(NodePath) var db_path = NodePath("/root/Database")

var family_dict: Dictionary = {}
var labourers_array: Array = []
var labourer: PersonResource
onready var database = get_node_or_null(db_path)

func set_labourer_person(person: PersonResource):
    labourer = person

func start_year():
    update_all_to_db()

func update_all_to_db():
    update_family_to_db()
    update_labourers_to_db()

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

func update_labourers_to_db():
    var n_labourers: int = database.get_generic_amount("labourer", database.LABOUR_TABLE)
    var d_l: int = n_labourers-labourers_array.size()
    if d_l > 0:
        for _i in range(d_l):
            labourers_array.append(add_person(labourer))
    else:
        for _i in range(-d_l):
            var l:Node = labourers_array.pop_back()
            remove_child(l)
            l.queue_free()
    assert(labourers_array.size() == n_labourers)

func add_person(person: Resource) -> Sprite:
    var sprite = Sprite.new()
    sprite.texture = person.image
    var scale = 0.5
    sprite.scale = Vector2(scale, scale)
    var nr_people = family_dict.size()+labourers_array.size()
    sprite.position += sprite.scale*Vector2(50.0*nr_people,-sprite.texture.get_size().y /2)
    add_child(sprite)
    return sprite

