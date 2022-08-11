extends Resource
class_name FamilyResource

export(Array) var family
export(Array) var on_farm_members
export(Array) var off_farm_members

func initialize():
    on_farm_members = family.duplicate()

func move_off_farm(person: PersonResource):
    if not person:
        printerr("move_off_farm called without a person (probably bc of strong typing)")
        return
    if not person in on_farm_members:
        printerr("person is not on farm: ", person.resource_name)
        return
    on_farm_members.erase(person)
    off_farm_members.append(person)

func move_on_farm(person: PersonResource):
    if not person:
        printerr("move_on_farm called without a person (probably bc of strong typing)")
        return
    if not person in off_farm_members:
        printerr("person is not off farm: ", person.resource_name)
        return
    off_farm_members.erase(person)
    on_farm_members.append(person)
