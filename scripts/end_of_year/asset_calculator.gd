extends EOYCalculator
class_name AssetCalculator
# calculates and makes summaries from bought/sold assets

var summaries: Array = []
var subtotal: float

func end_of_year(_event: EventResource) -> void:
    subtotal = 0.0
    summaries = []
    db.db.verbosity_level=2
    for t_name in db.UNIQUE_TABLES:
        add_unique_sum(t_name)
    for t_name in [db.HOUSEHOLD_TABLE, db.LABOUR_TABLE]:
        add_generic_sum(t_name)
    print_debug("created asset summaries: ",summaries)
    db.add_summaries(db.ASSET_SUM_TABLE, summaries)
    db.db.verbosity_level=0

func add_unique_sum(table_name: String) -> void:
    var res_dict: Dictionary = db.static_resources[table_name]
    var d_items: Array = db.get_unique_changed_items(table_name)
    for d_item in d_items:
        var name: String = d_item["name"]
        var d_money: float = d_item["n"]*res_dict[name].unit_price
        if d_item["year_bought"] == db.year:
            # we bought this item this year
            summaries.append({
                "name":name,
                # "resource":res_dict[name],
                "amount":d_item["n"],
                "d_money":d_money,
            })
            subtotal += d_money
        elif d_item["year_sold"] == db.year:
            summaries.append({
                "name":name,
                # "resource":res_dict[name],
                "amount":-d_item["n"],
                "d_money":-d_money,
            })
            subtotal -= d_money
        else:
            print_debug("something went terribly wrong: ", d_item)

func add_generic_sum(table_name: String) -> void:
    var res_dict: Dictionary = db.static_resources[table_name]
    var items = db.get_generic_changed_items(table_name)
    for item in items:
        var d_money = res_dict[item["name"]].unit_price * item["d_amount"]
        summaries.append({
            "name":item["name"],
            "amount": item["d_amount"],
            "d_money": d_money,
        })
        subtotal += d_money


# 
