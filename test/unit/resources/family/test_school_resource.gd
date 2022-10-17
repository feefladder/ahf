extends GutTest

var family: FamilyResource
var school: SchoolResource
var child

func before_each():
    family = FamilyResource.new()
    var parent = PersonResource.new()
    family.family.append(parent)
    child = ChildResource.new()
    child.age = 6
    family.family.append(child)
    school = SchoolResource.new()
    school.min_age = 4
    school.max_age = 8
    school.years_till_finished = 2

func test_initialize():
    school.initialize(family)
    assert_eq_deep(school.eligible_children, {child: 0})

func test_eligible():
    school.initialize(family)
    assert_true(school.is_eligible(child))

    school.eligible_children[child] = school.years_till_finished
    assert_false(school.is_eligible(child))

func test_eligible_age():
    child.age = school.min_age
    assert_true(school.is_eligible(child))
    child.age = school.min_age - 1
    assert_false(school.is_eligible(child))
    child.age = school.max_age
    assert_true(school.is_eligible(child))
    child.age = school.max_age + 1
    assert_false(school.is_eligible(child))

func test_send_to_school():
    school.initialize(family)
    assert_eq(school.send_child_to_school(), child)
    assert_eq_deep(school.children_going, [child])

    assert_null(school.send_child_to_school())
    assert_eq_deep(school.children_going, [child])

func test_send_to_school_multiple():
    var child_2 = ChildResource.new()
    child_2.age = 7
    family.family.append(child_2)

    school.initialize(family)
    assert_eq_deep(school.eligible_children, {child: 0, child_2: 0})
    assert_eq(school.send_child_to_school(), child)
    assert_eq(school.send_child_to_school(), child_2)
    assert_null(school.send_child_to_school())
    assert_eq_deep(school.children_going, [child, child_2])

func test_call_from_school():
    school.initialize(family)
    assert_eq(school.send_child_to_school(), child)
    assert_eq(school.call_child_from_school(), child)
    assert_eq_deep(school.children_going, [])

func test_next_year():
    school.initialize(family)
    assert_eq(school.send_child_to_school(), child)
    school.next_year()

    assert_eq_deep(school.children_going, [])
    assert_eq_deep(school.eligible_children, {child: 1})


func test_secondary_school():
    var secondary_school = SchoolResource.new()
    secondary_school.years_till_finished = 2
    secondary_school.min_age = 6
    secondary_school.max_age = 16
    secondary_school.previous_education = school

    school.initialize(family)
    secondary_school.initialize(family)
    assert_eq_deep(school.eligible_children, {child: 0})
    assert_true(school.is_eligible(child))

    assert_eq_deep(secondary_school.eligible_children, {})
    assert_false(secondary_school.is_eligible(child))

    school.eligible_children[child] = school.years_till_finished
    gut.p(school.eligible_children)
    gut.p(secondary_school.previous_education.eligible_children)
    assert_true(secondary_school.is_eligible(child))
    assert_eq_deep(secondary_school.eligible_children, {child: 0})

    assert_eq(secondary_school.send_child_to_school(), child)
