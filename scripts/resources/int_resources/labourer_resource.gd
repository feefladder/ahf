extends IntResource
class_name LabourerResource

export(Resource) var person

func _init():
    if person != null:
        image = person.image
        unit_labour = person.labour
