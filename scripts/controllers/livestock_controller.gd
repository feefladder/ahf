extends BigMenu
class_name LivestockController

signal animals_changed(which, new_amount)

func try_increase_resource(item: IntResource) -> int:
    if database.get_unique_int_items(item.resource_name, database.LIVESTOCK_TABLE).size() >= item.max_number:
        return -1
    if not asset_manager.has_enough(item.unit_price, item.unit_labour):
        return -1
    var id: int = database.add_unique_int_item(item.resource_name, database.LIVESTOCK_TABLE)
    asset_manager.buy_item(item)
    display.add_animal(item, id)
    var new_amount: int = database.get_unique_int_items(item.resource_name, database.LIVESTOCK_TABLE).size()
    emit_signal("animals_changed", item.resource_name, new_amount)
    return new_amount

func try_decrease_resource(item: IntResource) -> int:
    if database.get_unique_int_items(item.resource_name, database.LIVESTOCK_TABLE).size() == 0:
        return -1
    var id: int = database.remove_unique_int_item(item.resource_name, database.LIVESTOCK_TABLE)
    display.remove_animal(id)
    asset_manager.sell_item(item)
    var new_amount: int = database.get_unique_int_items(item.resource_name, database.LIVESTOCK_TABLE).size()
    emit_signal("animals_changed", item.resource_name, new_amount)
    return new_amount

# no toggle items or anything to do with resources
