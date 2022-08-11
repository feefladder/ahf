extends IntResource
class_name SchoolResource

export(int) var min_age
export(int) var max_age
export(int) var years_till_finished
export(Resource) var previous_education = null

var eligible_children := {}
var children_going := []

func _get_max() -> int:
    return eligible_children.size()

func send_child_to_school() -> ChildResource:
    for child in eligible_children:
        if is_eligible(child) and not child in children_going:
            children_going.append(child)
            return child
    return null

func call_child_from_school() -> ChildResource:
    if not children_going.size():
        return null
    return children_going.pop_back()

func next_year() -> void:
    for child in children_going:
        eligible_children[child] += 1
    children_going = []

func initialize(family: FamilyResource):
    for child in family.family:
        if child is ChildResource:
            if is_eligible(child):
                eligible_children[child] = 0

func is_eligible(child: ChildResource) -> bool:
    if child in eligible_children:
        if eligible_children[child] == years_till_finished:
            #education already completed
            return false
    if previous_education:
        if not child in previous_education.eligible_children:
            #not taken any previous education
            return false
        if previous_education.eligible_children[child] < previous_education.years_till_finished:
            # previous education not completed
            return false
    #return if child has the right age
    if child.age >= min_age and child.age <= max_age and not child in children_going:
        if not child in eligible_children:
            eligible_children[child] = 0
        return true
    else:
        return false
