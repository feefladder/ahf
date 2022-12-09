extends Node
class_name Database

const SQLite := preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

const FIELD_TABLE := "fields"
const FERTILITY_TABLE := "fertility"
const FBLOCK_TABLE := "field_blocks"
const LIVESTOCK_TABLE := "livestock"
const FAMILY_TABLE := "family"
const UPGRADE_TABLE := "upgrades"
const ASSET_TABLE := "assets"

signal database_loaded
signal resources_loaded(which, resources)

export(String) var base_path = "res://resources/"

export(Dictionary) var fields_to_paths = {
    "crop" : "crops/",
    "livestock" : "livestock/",
    "labour" : "labour/",
    "structural_measure" : "structural_measures/",
    "measure_improvement" : "measure_improvements/",
    "fertilization" : "fertilizers/",
    "irrigation" : "irrigation/",
    "family" : "family/",
    "events" : "events/"
}


var db_name = "res://db/db.db"
var static_resources: Dictionary = {}
var db: SQLite
var year := 1
var initializer : Initializer

func _init():
    initializer = Initializer.new()
    add_child(initializer)
    _maybe_copy_db_to_user()
    db = SQLite.new()
    db.path = db_name
    db.verbosity_level = 0
    initializer.init_db()

func _exit_tree():
    clear_database()

func _ready():
    emit_signal("database_loaded")
    for key in fields_to_paths:
        emit_signal("resources_loaded", key, _load_resources(key))


# loads resources from the file paths, returns an array of resources and adds them to the dictionary
func _load_resources(key) -> Array:
    static_resources[key] = {}
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
            static_resources[key][resource.resource_name] = resource
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
            print("found: " + file_name)
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
    for tn in [ FIELD_TABLE,  FERTILITY_TABLE, FBLOCK_TABLE, LIVESTOCK_TABLE, FAMILY_TABLE, UPGRADE_TABLE, ASSET_TABLE]:
        success = success && db.drop_table(tn)
    db.close_db()
    return success

############################################
# Writes/updates on assets
############################################

#initializes a money row
func init_money(money: int) -> bool:
    db.open_db()
    return db.insert_row(ASSET_TABLE, {"year":year, "money":money})

func get_money() -> int:
    db.open_db()
    var rows = db.select_rows(ASSET_TABLE, "year="+str(year), ["money"])
    return rows[0]["money"]

func change_money(amount: int) -> int:
    db.open_db()
    var rows = db.select_rows(ASSET_TABLE, "year="+str(year), ["money"])
    var newmoney = rows[0]["money"]+amount
    db.update_rows(ASSET_TABLE, "year="+str(year), {"money":newmoney})
    return newmoney

############################################
# Writes/updates on livestock
############################################

func add_animal(type: String) -> bool:
    db.open_db()
    db.insert_row(LIVESTOCK_TABLE, {"year_bought":year,"type":type})
    db.close_db()

func get_animal(type: String) -> Array:
    db.open_db()
    var rows: Array = db.select_rows(LIVESTOCK_TABLE, "type="+type)
    db.close_db()
    return rows
    

############################################
# Writes/updates on field_block related data
############################################

# initialize a block in the table with coordinates
# returns true if successful and false otherwise
func add_block(block_x: int, block_y: int) -> bool:
    db.open_db()
    var blocks : Array = db.select_rows(FBLOCK_TABLE, "x= " + str(block_x) + " AND y=" + str(block_y) + " AND year="+str(year),["*"])
    if blocks.size() != 0:
        db.close_db()
        return false
    
    db.insert_row(FBLOCK_TABLE, {"x":block_x,"y":block_y,"year":year})
    db.close_db()
    return true

# get the corresponding resource (crop/measure/irrigation) from a block if it exists
# returns the resource or null
func get_block_resource(block_x: int, block_y: int, type: String) -> Resource:
    var condition = "x=" +str(block_x)+ " AND y=" +str(block_y)+" AND year="+str(year)

    db.open_db()
    var result: Array = db.select_rows(FBLOCK_TABLE, condition, [type])
    db.close_db()

    var resource_name = result[0][type]
    print("rname: ",resource_name)
    if resource_name == null:
        return null

    return static_resources[type][resource_name]

# writes e.g. a crop to a block if there is not a crop yet
# returns true if successful and false if there was already something there
func write_block_if_empty(block_x: int, block_y: int, type: String, value: String) -> bool:
    var condition := "x="+str(block_x)+" AND y="+str(block_y)+" AND year="+str(year)
    
    db.open_db()
    var row:Array = db.select_rows(FBLOCK_TABLE, condition, [type])
    if row[0][type] == null:
        # print_debug(db.query_result[0][type])
        # Change name of 'Amanda' to 'Olga' and her age to 30
        db.update_rows(FBLOCK_TABLE, condition, {type:value})
        db.close_db()
        return true
    db.close_db()
    return false

# empties the block
func empty_block_type(block_x: int, block_y: int, type: String) -> bool:
    var condition := "x=" + str(block_x) + " AND y=" + str(block_y) + " AND year="+str(year)
    print(type)
    db.open_db()
    var result: Array = db.select_rows(FBLOCK_TABLE, condition, [type])
    if result[0][type] != null:
        db.update_rows(FBLOCK_TABLE, condition, {type:null})
        db.close_db()
        return true
    else:
        db.close_db()
        return false
