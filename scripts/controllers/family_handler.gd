extends BigMenu
class_name FamilyHandler

var schools : Dictionary
var family : FamilyResource

func _ready():
    print_debug("ready")
    print(display)

func use_resource(resource) -> void:
    print(resource.resource_name, " used!")
    if resource is FamilyResource:
        resource.initialize()
        display.show_family(resource)
        family = resource
    elif resource is SchoolResource:
        print(resource.resource_name)
        schools[resource] = []
        if family:
            print("checking family for: ", resource.resource_name)
            resource.initialize(family)

func send_child_to_school(school: SchoolResource) -> void:
    var sent_child: ChildResource =  school.send_child_to_school()
    if not sent_child:
        printerr("send_child_to_school called with no eligible children!", school.resource_name)
        return

    family.move_off_farm(sent_child)
    display.hide_person(sent_child)

func call_child_from_school(school: SchoolResource):
    var called_child = school.call_child_from_school()
    if not called_child:
        printerr("call_child_from_school called when no child was going to the school: ", school.resource_name)

    family.move_on_farm(called_child)
    display.show_person(called_child)

func _on_int_item_increased(item):
    print("item increased!", item.get_class())
    if item is SchoolResource:
        print("school item increased! ", item.resource_name)
        send_child_to_school(item)

func _on_int_item_decreased(item):
    print("item decreased!")
    if item is SchoolResource:
        call_child_from_school(item)

func next_year():
    for school in schools:
        school.next_year()
    for member in family.family:
        if member is ChildResource:
            member.age += 1
            if member in family.off_farm_members:
                family.move_on_farm(member)
    display.update_family(family)
