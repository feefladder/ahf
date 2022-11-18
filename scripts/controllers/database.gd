extends Node
class_name Database

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

signal resources_loaded(which, resources)

export(String) var base_path = "res://resources/"

export(Dictionary) var fields_to_paths = {
    "crop_resource" : "crops/",
    "livestock_resource" : "livestock/",
    "labour_resource" : "labour/",
    "measures_resource" : "measures/",
    "family_resource" : "family/",
    "events_resource" : "events/"
}

var db_name = "res://db/db"
var static_resources: Dictionary = {}
var db: SQLite

func _ready():
    print_debug(get_tree().get_root().get_child(0))
    for key in fields_to_paths:
        emit_signal("resources_loaded", key, _load_resources(key))
    
    _maybe_copy_db_to_user()
    db = SQLite.new()
    db.path = db_name
    db.verbosity_level = 1 #2 VERBOSE 1 #NORMAL 0 #QUIET
    _mock_data()

func _mock_data():
    var table_name = "field_blocks"
    var row_dict = {
        "block_id" : 0,
        "x" : 0,
        "y" : 0,
        "crop" : "maize",
        "structural_measure" : null
       }
    
    db.open_db()
    db.insert_row(table_name, row_dict)
    db.query("select * from " + table_name + ";")
    print(db.query_result)
    db.close_db()
    print_debug(write_if_empty(0,0,"crop", "beans"))
    print_debug(write_if_empty(0,0,"structural_measure", "terraces"))
    db.open_db()
    db.delete_rows(table_name, "*")

func _load_resources(key) -> Array:
    static_resources[key] = []
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
            static_resources[key].append(load(base_path + resources_path + filename))
        filename = directory.get_next()

    return static_resources[key]

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

func write_if_empty(block_x: int, block_y: int, type: String, value: String) -> bool:
    var table_name = "field_blocks"
    var condition  = "x = " + str(block_x) + " AND y=" + str(block_y)
    db.open_db()
    db.query("SELECT " + type + " FROM " + table_name + " WHERE " + condition)
    if db.query_result[0][type] != null:
        print_debug(db.query_result[0][type])
        # Change name of 'Amanda' to 'Olga' and her age to 30
        db.update_rows(table_name, condition, {type:value})
        return true
    return false

#func write_to_db(block_x: int, block_y: int, type: String, value: String) -> bool:
#    # Open the database using the db_name found in the path variable
#    db.open_db()
