extends BigMenu
class_name LabourController

signal people_changed

func try_increase_resource(item: IntResource) -> int:
    if database.get_generic_amount(item.resource_name, database.LABOUR_TABLE) >= item.max_number:
        return -1
    # labourer
    if not asset_manager.has_enough(item.unit_price, item.unit_labour):
        return -1
    var new_amount : int = database.change_generic_item(item.resource_name, database.LABOUR_TABLE, 1)
    display.update_labourers_to_db()
    asset_manager.decrease_assets(item.unit_price, item.unit_labour)
    emit_signal("people_changed")
    return new_amount

func try_decrease_resource(item: IntResource) -> int:
    if database.get_generic_amount(item.resource_name, database.LABOUR_TABLE) <= 0:
        return -1
    # labourer
    if not asset_manager.has_enough(-item.unit_price, -item.unit_labour):
        return -1
    var new_amount : int = database.change_generic_item(item.resource_name, database.LABOUR_TABLE, -1)
    display.update_labourers_to_db()
    asset_manager.increase_assets(item.unit_price, item.unit_labour)
    emit_signal("people_changed")
    return new_amount

func try_toggle_item(item: BuyResource) -> bool:
    #only getting an off-farm job in this case -> has influence on family
    var amount = database.get_generic_amount(item.resource_name, database.LABOUR_TABLE)
    if amount == 0:
        # get an off farm job
        if not asset_manager.has_enough(item.unit_price, item.person.labour):
            return false
        # off farm job -> move off farm
        database.change_generic_item(item.resource_name, database.LABOUR_TABLE, 1)
        var person_moved = database.move_person(item.person.resource_name, false)
        if not person_moved:
            return false
        display.update_family_to_db()
        emit_signal("people_changed")
        asset_manager.decrease_assets(item.unit_price, 0)
    else:
        if not asset_manager.has_enough(-item.unit_price, -item.person.labour):
            return false
        # no off farm job -> move on farm
        database.change_generic_item(item.resource_name, database.LABOUR_TABLE, -1)
        var person_moved = database.move_person(item.person.resource_name, true)
        if not person_moved:
            return false
        display.update_family_to_db()
        emit_signal("people_changed")
        asset_manager.increase_assets(item.unit_price, 0)
    return true

func end_of_year():
    print_debug("end_of_year called on ",self)
    database.set_next(database.LABOUR_TABLE, "amount", 0)

func _use_resources(resources: Array) -> void:
    for resource in resources:
        database.add_generic_item(resource.resource_name, database.LABOUR_TABLE, 0)
        if resource is LabourerResource:
            display.set_labourer_person(resource.person)
    emit_signal("people_changed")
