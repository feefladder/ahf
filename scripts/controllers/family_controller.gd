extends BigMenu
class_name FamilyHandler

var schools : Dictionary

signal people_changed

func _ready():
	# warning-ignore:return_value_discarded
	connect("people_changed", asset_controller, "_on_people_changed")

func try_increase_resource(an_item: IntResource) -> int:
	if an_item is SchoolResource:
		return send_child_to_school(an_item)
	else:
		return 0

func try_decrease_resource(an_item: IntResource) -> int:
	if an_item is SchoolResource:
		return call_child_from_school(an_item)
	else:
		return 0

func try_toggle_item(item: BuyResource) -> bool:
	# health insurance
	var amount = database.get_generic_amount(item.resource_name, database.HOUSEHOLD_TABLE)
	if amount == 0:
		# get health insurance
		if not asset_controller.has_enough(item.unit_price, item.unit_labour):
			return false
		if database.change_generic_item(item.resource_name, database.HOUSEHOLD_TABLE , 1) != 1:
			print_debug("something went terribly wrong!")
			return false
		return asset_controller.buy_item(item)
	else:
		if not asset_controller.has_enough(-item.unit_price, -item.unit_labour):
			return false
		if database.change_generic_item(item.resource_name, database.HOUSEHOLD_TABLE ,-1) != 0:
			print_debug("something went terribly wrong!")
			return false
		return asset_controller.sell_item(item)

func _use_resources(resources:Array) -> void:
	if resources[0] is IntResource:
		for resource in resources:
			if resource is SchoolResource:
				schools[resource] = []
			database.add_generic_item(resource.resource_name, database.HOUSEHOLD_TABLE, 0)
	elif resources[0] is PersonResource:
		database.add_family(resources)
		display.update_family_to_db()

func send_child_to_school(school: SchoolResource) -> int:
	#send a child to school:
	# - call the database to get children that are not going to school:
	# - get_children_where(school_years-previous_school_years=0 and age<school.max_age and age>school.min_age)
	# children cannot work so no labour involved -> here for consistency
	if not asset_controller.has_enough(school.unit_price, school.unit_labour):
		return -1

	var children: Array = database.get_eligible_children(school)
	print_debug("eligible_children: ", children)
	if children.size() == 0:
		return -1 # no eligible children
	# send the child that has had the most years on this school and if equal, the oldest
	var child_going = children[0]
	asset_controller.buy_item(school)
	# move child off farm
	database.send_child_to_school(child_going["id"], school)
	database.move_person(child_going["name"], false)
	display.update_family_to_db()
	return database.change_generic_item(school.resource_name, database.HOUSEHOLD_TABLE, 1)


func call_child_from_school(school: SchoolResource) -> int:
	#call a child from school:
	# - call the database to get children that are not going to school:
	# - get_children_where(school_years-previous_school_years=1) #implicitly already has age requirement
	var children: Array = database.get_children_going_to_school(school)
	if children.size() == 0:
		print_debug("tried to call child from school, but none were going")
		return -1
	var child_coming = children[0]
	asset_controller.sell_item(school)
	# move child on farm
	database.call_child_from_school(child_coming["id"], school)
	database.move_person(child_coming["name"], true)
	display.update_family_to_db()
	return database.change_generic_item(school.resource_name, database.HOUSEHOLD_TABLE, -1)

func end_of_year():
	database.increment_next(database.FAMILY_TABLE, "age")
	database.set_next(database.FAMILY_TABLE, "on_farm", true)
	database.set_next(database.HOUSEHOLD_TABLE, "amount", 0)

func start_year():
	display.update_family_to_db()
	for menu_item in item_container.get_children():
		var resource = menu_item.resource
		var amount:int = database.get_generic_amount(resource.resource_name, database.HOUSEHOLD_TABLE)
		if "amount" in menu_item:
			menu_item.amount = amount
		elif menu_item.has_method("set_toggle"):
			menu_item.set_toggle(amount >= 1)
