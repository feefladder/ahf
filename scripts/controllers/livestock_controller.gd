extends BigMenu

func try_increase_resource(item: IntResource) -> int:
    if database.get_unique_int_items(item.resource_name, database.LIVESTOCK_TABLE).size() >= item.max_number:
        return -1
    if not asset_manager.has_enough(item.unit_price, item.unit_labour):
        return -1
    var id: int = database.add_unique_int_item(item.resource_name, database.LIVESTOCK_TABLE)
    asset_manager.decrease_assets(item.unit_price, item.unit_labour)
    display.add_animal(item, id)
    return database.get_unique_int_items(item.resource_name, database.LIVESTOCK_TABLE).size()

func try_decrease_resource(item: IntResource) -> int:
    if database.get_unique_int_items(item.resource_name, database.LIVESTOCK_TABLE).size() == 0:
        return -1
    var id: int = database.remove_unique_int_item(item.resource_name, database.LIVESTOCK_TABLE)
    display.remove_animal(id)
    asset_manager.increase_assets(item.unit_price, item.unit_labour)
    return database.get_unique_int_items(item.resource_name, database.LIVESTOCK_TABLE).size()

# no toggle items or anything to do with resources

func next_year():
    pass # Replace with function body.
