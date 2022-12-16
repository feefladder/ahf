extends BigMenu
class_name LabourController

signal people_changed

func try_buy_item(item: IntResource) -> bool:
    # labourer
    if not asset_manager.has_enough(item.money, item.labour):
        return false
    var success : bool = database.change_generic_item(item.resource_name, 1)
    if not success:
        return false
    asset_manager.decrease_assets(item.money,0)
    emit_signal("people_changed")
    return success

func try_sell_item(item: IntResource) -> bool:
    # labourer
    if not asset_manager.has_enough(-item.money, -item.labour):
        return false
    var success : bool = database.change_generic_item(item.resource_name, -1)
    if not success:
        return false
    asset_manager.increase_assets(item.money,0)
    emit_signal("people_changed")

    display.remove_labourer() # make respond to signal?
    return success

func try_toggle_item(item: BuyResource) -> bool:
    #only getting an off-farm job in this case -> has influence on family
    var amount = database.get_generic_amount(item.resource_name, database.LABOUR_TABLE)
    if amount == 0:
        # get an off farm job
        if not asset_manager.has_enough(item.money, item.person.labour):
            return false
        # off farm job -> move off farm
        var person_moved = database.move_person(item.person.resource_name, false)
        if not person_moved:
            return false
        display.move_person(person_moved,false)
        emit_signal("people_changed")
        asset_manager.decrease_assets(item.money, 0)

    else:
        if not asset_manager.has_enough(-item.money, -item.person.labour):
            return false
        # no off farm job -> move on farm
        var person_moved = database.move_person(item.person.resource_name, true)
        if not person_moved:
            return false
        display.move_person(person_moved,true)
        emit_signal("people_changed")
        asset_manager.increase_assets(item.money, 0)

    return false

func next_year():
    pass # Replace with function body.

func _use_resources(resources: Array) -> void:
    for resource in resources:
        database.add_generic_item(resource.resource_name, database.LABOUR_TABLE)
    emit_signal("people_changed")
