extends EOYCalculator
class_name AssetCalculator
# calculates and makes summaries from bought/sold assets

var summaries: Array = []
var subtotal: float

func end_of_year(_event: EventResource) -> void:
    subtotal = 0.0
    summaries = []
    db.db.verbosity_level=2
    for t_name in [db.LIVESTOCK_TABLE]:#, db.UPGRADE_TABLE]: #TODO: implement uprgades
        add_unique_sum(t_name)
    for t_name in [db.HOUSEHOLD_TABLE, db.LABOUR_TABLE]:
        add_generic_sum(t_name)
    print_debug("created asset summaries: ",summaries)
    db.add_summaries(db.ASSET_SUM_TABLE, summaries)
    db.db.verbosity_level=0
    if subtotal != get_parent().used_money:
        print_debug("oh noes, calculations do not match!", subtotal, get_parent().used_money)


func add_unique_sum(table_name: String) -> void:
    var res_dict: Dictionary = db.static_resources
    var d_items: Array = db.get_unique_changed_items(table_name)
    for d_item in d_items:
        var name: String = d_item["name"]
        var d_money: float = d_item["n"]*res_dict[name].unit_price
        print_debug("item: ", d_item, d_money)
        if d_item["year_bought"] == db.year:
            # we bought this item this year -> money is negative
            summaries.append({
                "name":name,
                # "resource":res_dict[name],
                "amount":d_item["n"],
                "d_money":-d_money,
            })
            subtotal += d_money
        elif d_item["year_sold"] == db.year:
            # we sold this item this year -> money is positive
            summaries.append({
                "name":name,
                # "resource":res_dict[name],
                "amount":-d_item["n"],
                "d_money":d_money,
            })
            subtotal -= d_money
        else:
            print_debug("something went terribly wrong: ", d_item)

func add_generic_sum(table_name: String) -> void:
    var res_dict: Dictionary = db.static_resources
    var items = db.get_generic_amounts(table_name, "amount IS NOT NULL")
    print_debug(items)
    for item in items:
        var d_money = -res_dict[item["name"]].unit_price * item["amount"]
        summaries.append({
            "name":item["name"],
            "amount": item["amount"],
            "d_money": d_money,
        })
        subtotal += d_money


# 
