extends Node
class_name FamilyDisplay

var people_dict: Dictionary = {}

func  show_family(family: FamilyResource):
    print(family.family)
    for member in family.on_farm_members:
        var sprite = add_person(member)
        people_dict[member] = sprite

func add_person(person: Resource) -> Sprite:
    var sprite = Sprite.new()
    sprite.texture = person.image
    var scale = 0.5
    sprite.scale = Vector2(scale, scale)
    sprite.position += sprite.scale*Vector2(50.0*people_dict.size(),-sprite.texture.get_size().y /2)
    add_child(sprite)
    return sprite

func show_person(person: PersonResource):
    people_dict[person].show()

func hide_person(person: PersonResource):
    people_dict[person].hide()

func update_family(family: FamilyResource):
    if not family.family.size() == people_dict.size():
        printerr("re-initialize of family display required (TODO)")
    for person in people_dict:
        if person in family.on_farm_members:
            people_dict[person].show()
        elif person in family.off_farm_members:
            people_dict[person].hide()
        else:
            printerr("person in family neither on-farm or off-farm: ", person.resource_name)
            remove_all_labourers(person)

func increase_int_item(item):
    if item is PersonResource:
        add_labourer(item)

func decrease_int_item(item):
    if item is PersonResource:
        remove_labourer(item)

func _on_int_item_increased(which: IntResource):
    add_labourer(which)

func _on_int_item_decreased(which: IntResource):
    remove_labourer(which)

func add_labourer(labourer: IntResource) -> void:
    var sprite = add_person(labourer)
    if not labourer in people_dict:
        people_dict[labourer] = [sprite]
    else:
        people_dict[labourer].append(sprite)

func remove_all_labourers(labourer: IntResource) -> void:
    if not labourer in people_dict:
        printerr("remove_labourer called with invalid labourer! " + labourer.resource_name)
        return
    
    for sprite in people_dict[labourer]:
        sprite.queue_free()
    assert(people_dict.erase(labourer) == true)

func remove_labourer(labourer: IntResource) -> void:
    if not labourer in people_dict:
        printerr("remove_labourer called with invalid labourer! " + labourer.resource_name)
        return
    
    var sprite = people_dict[labourer].pop_back()
    sprite.queue_free()
    if not people_dict[labourer].size():
        assert(people_dict.erase(labourer) == true)
