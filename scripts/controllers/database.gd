extends Node
class_name Database

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

# table with id and water source
const FIELD_TABLE := "fields"
# tables that get creaeted based on resource values (field, fertility)
const RESOURCE_TABLES := "resources"
# field blocks with crops etc
const FBLOCK_TABLE := "field_blocks"
#livestock (unique resources)
const LIVESTOCK_TABLE := "livestock"
# family (unique, with on-farm and age)
const FAMILY_TABLE := "family"
# table with schools and others (insurance)
const HOUSEHOLD_TABLE := "household"
# table with school years for each family member
const SCHOOL_TABLE := "school"
# table with upgrades (house, car etc)
const UPGRADE_TABLE := "upgrades"
# table with money and used labour
const ASSET_TABLE := "assets"
# table with items bought and sold this year
const BUY_SELL_TABLE := "buy_sell"
# table with items that can be bought and sold
const BUYRESOURCE_TABLE := "buyresources"
# table with labourers and off-farm job
const LABOUR_TABLE := "labour"

# table with event that happened this year
const EVENT_SUM_TABLE := "events"
# table with crop yields
const CROP_SUM_TABLE := "crop_summary"
# table with additional income/costs (living expenses, sickness)
const ASSET_SUM_TABLE := "asset_summary"
# table with livestock income
const LIV_SUM_TABLE := "livestock_summary"

const FIELD_TABLES := [
    # FERTILITY_TABLE,
    FBLOCK_TABLE,
    FIELD_TABLE, #Fert and Fblock have foreign keys
]

const ASSET_TABLES := [
    ASSET_TABLE,
    BUY_SELL_TABLE,
    BUYRESOURCE_TABLE,
]

const PEOPLE_TABLES := [
    SCHOOL_TABLE, #has foreign keys to household and family
    HOUSEHOLD_TABLE, #has schools
    FAMILY_TABLE,
    LABOUR_TABLE,
]

const UNIQUE_TABLES := [
    LIVESTOCK_TABLE,
    UPGRADE_TABLE,
]

const SUMMARY_TABLES := [
    EVENT_SUM_TABLE,
    CROP_SUM_TABLE,
    ASSET_SUM_TABLE,
    LIV_SUM_TABLE,
]

const ALL_TABLES := (
    ASSET_TABLES+
    FIELD_TABLES+
    PEOPLE_TABLES+
    UNIQUE_TABLES+
    SUMMARY_TABLES
)

const field_cols := [
        "crop",
        "structural_measure",
        "measure_improvement",
        "fertilization",
        "irrigation",
    ]

signal database_loaded
signal resources_loaded(which, resources)
signal all_resources_loaded

export(String) var base_path = "res://resources/"

export(Dictionary) var fields_to_paths = {
    LIVESTOCK_TABLE : "livestock/",
    LABOUR_TABLE : "labour/",
    FAMILY_TABLE : "family/",
    HOUSEHOLD_TABLE : "household/",
    UPGRADE_TABLE : "upgrades/",
    RESOURCE_TABLES : "db_resources/",
    field_cols[0] : "crops/",
    field_cols[1] : "structural_measures/",
    field_cols[2] : "measure_improvements/",
    field_cols[3] : "fertilizers/",
    field_cols[4] : "irrigation/",
    EVENT_SUM_TABLE : "events/"
}


var db_name = "res://db/db.db"
var static_resources: Dictionary = {}
var db: SQLite
var year := 1 setget _set_year, _get_year
var initializer : Initializer
var default_field := -1
var resource_table_columns :Dictionary = {}

# tables that are initialized based on the properties of the resource
var resource_tables := [
    # Add more whenever there is a resource that changes its values rather than amount
    # over time (maybe assets? -> no)
]



func _init():
    initializer = Initializer.new()
    add_child(initializer)
    _maybe_copy_db_to_user()
    db = SQLite.new()
    db.path = db_name
    db.verbosity_level = 0
    db.foreign_keys = true
    if not initializer.init_db():
        printerr("something went wrong while initializing the database")

func _exit_tree():
    if not obliterate_database():
        printerr("some error while clearing database!")

func _ready():
    emit_signal("database_loaded")
    # warning-ignore:return_value_discarded
    # connect("resources_loaded", initializer, "_on_resources_loaded")
    for key in fields_to_paths:
        emit_signal("resources_loaded", key, _load_resources(key))
    emit_signal("all_resources_loaded")


# loads resources from the file paths, returns an array of resources and adds them to the dictionary
func _load_resources(key) -> Array:
    var resources =[]
    var resources_path = fields_to_paths[key]
    # TODO: make this class call some API endpoint whenever the game actually implements it
    var directory = Directory.new()
    if not directory.open(base_path + resources_path) == OK:
        printerr("could not load: ", base_path, resources_path)
        return []
    directory.list_dir_begin()

    var filename = directory.get_next()
    while(filename):
        if not directory.current_is_dir() and filename.ends_with(".tres"):
            var resource = load(base_path + resources_path + filename)
            static_resources[resource.resource_name] = resource
            resources.append(resource)
        filename = directory.get_next()
    return resources

func _maybe_copy_db_to_user() -> void:
    if OS.get_name() in ["Android", "iOS", "HTML5"]:
        _copy_db_to_user()
        db_name = "user://db/test"

func _copy_db_to_user() -> void:
    var data_path := "res://db"
    var copy_path := "user://db"

    var dir = Directory.new()
    dir.make_dir(copy_path)
    if dir.open(data_path) == OK:
        dir.list_dir_begin();
        var file_name = dir.get_next()
        while (file_name != ""):
            if dir.current_is_dir():
                pass
            else:
                print("Copying " + file_name + " to /user-folder")
                dir.copy(data_path + "/" + file_name, copy_path + "/" + file_name)
            file_name = dir.get_next()
    else:
        printerr("An error occurred when trying to access the path.")

func clear_database() -> bool:
    var success : bool = true
    db.open_db()
    for tn in ALL_TABLES + resource_tables:
        success = success and db.delete_rows(tn,"1=1")
    db.close_db()
    return success

func obliterate_database() -> bool:
    var success : bool = true
    db.open_db()
    for tn in ALL_TABLES + resource_tables:
        success = success and db.drop_table(tn)
    db.close_db()
    return success

#############################################
# functions to control what happens at the end of the year.
# These work on the next year
# ###########################################

func _set_year(new_year: int) -> bool:
    if new_year < year:
        return false
    # do some necessary stuff like checking if all tables have values corresponding to this year
    year = new_year
    return true

func _get_year() -> int:
    return year

func increase_all_tables_years() -> bool:
    var success = true
    for table in (
        [ASSET_TABLE]+
        FIELD_TABLES+
        PEOPLE_TABLES+
        resource_tables
    ):
        success = increase_year(table) and success
    return success

func increase_year(table_name: String) -> bool:
    db.open_db()
    # because we want to work with ids on things and don't want them to change, we first
    # increase the year by 1 and then copy the values to have the current year
    var success : bool = db.query("UPDATE "+table_name+" SET year=year+1 WHERE year="+str(year))
    success = success and db.query(
        # create a temporary table with all columns
        "CREATE TEMPORARY TABLE temp_table AS SELECT * FROM "+table_name+" WHERE year="+str(year+1)+"; "+
        # change year to current year and set id to null, so it is autogenerated
        "UPDATE temp_table SET year="+str(year)+", id=NULL; "+
        # insert into the table
        "INSERT INTO "+table_name+" SELECT * FROM temp_table; "
        )
    db.close_db()
    return success

func increment_next(table_name: String, column:String, name:String="") -> bool:
    var condition = "year="+str(year+1)
    if name != "":
        condition += " AND name='"+name+"'"
    db.open_db()
    var success:bool=db.query(
        " UPDATE "+table_name+
        " SET "+column+"="+column+"+1"+
        " WHERE "+condition
        )
    db.close_db()
    return success

# generic function to reset value
func set_next(table_name:String, column:String, set_to, additional_conditions: String="") -> bool:
    var condition = "year="+str(year+1)+" "+additional_conditions
    db.open_db()
    var success:bool=db.update_rows(table_name,condition,{column: set_to})
    db.close_db()
    return success

func set_next_dict(table_name:String, values: Dictionary, additional_conditions: String="") -> bool:
    var condition = "year="+str(year+1)+" "+additional_conditions
    db.open_db()
    var success:bool=db.update_rows(table_name,condition,values)
    db.close_db()
    return success

############################################
# Writes/updates on summaries
############################################

func get_resource(resource_name: String) -> Resource:
    if static_resources.get(resource_name):
        return static_resources.get(resource_name)
    return null

func add_summary(table_name: String, values: Dictionary) -> int:
    values["year"] = year #this actually modifies the dict - maybe copy
    db.open_db()
    var success: bool = db.insert_row(table_name, values)
    var id: int = db.last_insert_rowid
    db.close_db()
    if success:
        return id
    else:
        return 0

func add_summaries(table_name: String, summaries: Array) -> bool:
    for s in summaries:
        s["year"] = year #this actually modifies the array - maybe copy?
    db.open_db()
    var success: bool = db.insert_rows(table_name, summaries)
    db.close_db()
    return success

func get_summary(table_name: String) -> Array:
    db.open_db()
    db.query("SELECT * FROM "+table_name+" WHERE year="+str(year))
    var summary:Array = db.query_result
    db.close_db()
    return summary.duplicate()

func get_avg_summary(table_name: String, col: String, group_by: String) -> Array:
    db.open_db()
    db.query(
        " SELECT AVG("+col+") AS "+col+"_avg, COUNT("+group_by+") AS "+group_by+"_n, "+group_by+
        " FROM "+table_name+
        " WHERE year="+str(year)+
        " GROUP BY "+group_by
        )
    var result: Array = db.query_result
    db.close_db()
    return result.duplicate(true)

func get_asset_summary(condition: String="1=1", col:String="unit_price") -> Array:
    db.open_db()
    db.query(
        " SELECT amount, name, "+col+" FROM "+BUY_SELL_TABLE+
        "   LEFT JOIN "+BUYRESOURCE_TABLE+" ON id_resource="+BUYRESOURCE_TABLE+".id"+
        " WHERE year="+str(year)+" AND "+condition
    )
    var result: Array = db.query_result
    db.close_db()
    return result.duplicate(true)

############################################
# Writes/updates on items
############################################

#unique int items are stored with "year_bought" column and are sold with "year_sold"
#column
#thus they allow for you to track over time which is which
func add_unique_int_item(name: String, table_name: String=LIVESTOCK_TABLE) -> int:
    var c_just_sold = "year_sold='"+str(year)+"'"
    db.open_db()
    var result: Array = db.select_rows(table_name, c_just_sold, ["id"])
    var id:int=0
    var success:bool=false
    if result.size():
        id = result[0]["id"]
        success = db.update_rows(table_name, "id="+str(id), {"year_sold":null})
    else:
        success = db.insert_row(table_name, {"year_bought":year,"name":name})
        id = db.last_insert_rowid
    db.close_db()
    if success:
        return id
    else:
        return 0

# sell an item. prefers to sell items that were bought this year
func remove_unique_int_item(name: String, table_name: String) -> int:
    var c_just_bought = "name='"+name+"' AND year_bought="+str(year)
    var c_not_sold = "name='"+name+"' AND year_sold IS NULL"
    db.open_db()
    var result: Array = db.select_rows(table_name, c_just_bought, ["id"])
    var id = -1
    if not result.size():
        result = db.select_rows(table_name, c_not_sold, ["id"])
        if not result.size():
            db.close_db()
            return id
        else:
            id = result[0]["id"]
            if not db.update_rows(table_name, "id="+str(id), {"year_sold":year}):
                db.close_db()
                return -1
    else:
        id= result[0]["id"]
        if not db.delete_rows(table_name, "id="+str(id)):
            db.close_db()
            return -1
    db.close_db()
    return id

func get_unique_int_items(name: String, table_name: String=LIVESTOCK_TABLE) -> Array:
    db.open_db()
    var result: Array = db.select_rows(table_name, "name='"+name+"' AND year_sold IS NULL", ["id","name","year_bought"])
    db.close_db()
    return result.duplicate(true)

func get_unique_changed_item(name: String, table_name: String=LIVESTOCK_TABLE) -> Array:
    var condition = "name='name"+name+"' AND ( year_bought="+str(year)+" OR year_sold="+str(year)+" )"
    db.open_db()
    var result: Array = db.select_rows(table_name, condition, ["id","year_bought","year_sold"])
    db.close_db()
    return result.duplicate(true)

func get_unique_changed_items(table_name: String=LIVESTOCK_TABLE) -> Array:
    var condition = "year_bought="+str(year)+" OR year_sold="+str(year)
    db.open_db()
    db.query("SELECT name, year_bought, year_sold, COUNT(name) AS n"+
        " FROM "+table_name+
        " WHERE "+condition+
        " GROUP BY name"
    )
    var result: Array = db.query_result
    db.close_db()
    return result.duplicate(true)


# generic int items are stored each year with an "amount" column and tracked by
# comparing columns
func add_generic_item(name:String, table_name:String, amount) -> int:
    # adds a row for this item, returns the id
    db.open_db()
    var success = db.insert_row(table_name,{"name":name, "amount":amount, "year":year})
    var id = db.last_insert_rowid
    db.close_db()
    if success:
        return id
    else:
        return 0

func get_generic_amounts(table_name: String, additional_conditions: String = "1=1") -> Array:
    db.open_db()
    var result: Array = db.select_rows(table_name,"year="+str(year)+" AND "+additional_conditions,["name","amount"])
    db.close_db()
    # for row in result:
    #     var name: String = row["name"]
    #     row[name+"_resource"] = static_resources[name]
    return result.duplicate(true)


func get_generic_amount(name: String, table_name: String):
    var condition = "name='"+name+"' AND year="+str(year)
    db.open_db()
    var row = db.select_rows(table_name, condition, ["amount"])
    db.close_db()
    assert(row.size() == 1)
    return row[0]["amount"]

func change_generic_item(name:String, table_name:String, d_amount) -> int:
    var condition = "name='"+name+"' AND year="+str(year)
    db.open_db()
    var success: bool = db.query("UPDATE "+table_name+" SET amount=amount+"+str(d_amount)+" WHERE "+condition+";")
    db.close_db()
    if success:
        return get_generic_amount(name, table_name)
    else:
        return -1

func buy_sell_item(name: String, table_name: String, d_amount: int) -> bool:
    print_debug(d_amount)
    db.open_db()
    # get the resource id from BUYRESOURCE_TABLE
    var id_resource: int=db.select_rows(BUYRESOURCE_TABLE, "name='"+name+"'", ["id"])[0]["id"]
    # make query condition with resource id
    var condition: String = "year="+str(year)+" AND id_resource='"+str(id_resource)+"'"
    var row = db.select_rows(table_name, condition, ["amount"])
    if row.size() == 1:
        if row[0]["amount"] + d_amount == 0:
            db.delete_rows(table_name,condition)
        else:
            db.update_rows(table_name,condition,{"amount":row[0]["amount"]+d_amount})
    elif row.size() == 0:
        if not db.insert_row(table_name,{
            "year":year,
            "id_resource":id_resource,
            "amount":d_amount,
        }):
            print_debug("failed inserting row for: ", name)
            db.close_db()
            return false
    else:
        print_debug("something went terribly wrong!")
        db.close_db()
        return false
    db.close_db()
    return true
        

func get_generic_changed_items(table_name: String) -> Array:
    # https://learnsql.com/blog/difference-between-two-rows-in-sql/

    var query_string:=(
        "SELECT name, amount, d_amount FROM "+
            "(SELECT name, year, amount, amount - LAG(amount) "+
                    "OVER ( PARTITION BY name ORDER BY year ) AS d_amount "+
            "FROM "+table_name+" WHERE year="+str(year-1)+" OR year="+str(year)+" ) "+
        "WHERE year="+str(year)+" AND d_amount !=0;"
    )
    db.open_db()
    db.query(query_string)
    var result = db.query_result
    db.close_db()
    return result.duplicate(true)

###########################################
# Writes/updates on fertility
###########################################

func get_current_fertility(cols:Array, field=0)->Array:
    if not field:
        field=default_field
    db.open_db()
    var result = db.select_rows("FertilityResource", #TODO: make nice
        "year="+str(year)+
        " AND field="+str(field)
        ,cols)
    db.close_db()
    return result.duplicate(true)


###########################################
# Writes/updates on family
###########################################

# write family to database
# parameters:
#  family: Array of PersonResource
# returns: bool success of transaction
func add_family(family: Array)->bool:
    var row_array=[]
    var mdict:Dictionary = {}
    for member in family:
        mdict = {
            "year":year,
            "name":member.resource_name,
            "on_farm":1,
            "age":member.age,
        }
        row_array.append(mdict.duplicate())
        mdict.clear()

    db.open_db()
    var success:bool=db.insert_rows(FAMILY_TABLE,row_array)
    db.close_db()
    return success

func move_person(name: String, on_farm: bool) -> int:
    db.open_db()
    var row = db.select_rows(FAMILY_TABLE,"name='"+name+"' AND year="+str(year),["id","on_farm"])
    assert(row.size() == 1)
    if row[0]["on_farm"] == int(on_farm):
        db.close_db()
        printerr("tried to move "+name+", while they're are already "+str(on_farm)+str(row[0]["on_farm"])+" on farm")
        return 0
    var person_moved: int = row[0]["id"]
    db.update_rows(FAMILY_TABLE, "id="+str(person_moved), {"on_farm":on_farm})
    db.close_db()
    return person_moved

func get_family() -> Array:
    db.open_db()
    var result = db.select_rows(FAMILY_TABLE, "year="+str(year), ["id","name","on_farm"])
    db.close_db()
    for person in result:
        person["resource"] = static_resources[person["name"]]
    return result.duplicate(true)
