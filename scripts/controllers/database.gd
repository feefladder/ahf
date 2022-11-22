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

func _load_resources(key) -> Array:
    static_resources[key] = {}
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
        filename = directory.get_next()

    return static_resources[key].values()

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
    var table_name := "field_blocks"
    var bindings := [block_x, block_y]
    # var query_string := "SELECT " + type + " FROM " + table_name + " WHERE x=? AND y=?;"
    var query_string := "SELECT * FROM " + table_name +" WHERE x= " + str(block_x) + " AND y=" + str(block_y) + ";"
    var condition := "x=" + str(block_x) + " AND y=" + str(block_y)
    
    db.open_db()
    # db.query_with_bindings(query_string, bindings)
    db.query(query_string)
    if db.query_result[0][type] == null:
        # print_debug(db.query_result[0][type])
        # Change name of 'Amanda' to 'Olga' and her age to 30
        db.update_rows(table_name, condition, {type:value})
        db.close_db()
        return true
    db.close_db()
    return false

func empty_cell(block_x: int, block_y: int, type: String) -> bool:
    var table_name := "field_blocks"
    var bindings := [block_x, block_y]
    # var query_string := "SELECT " + type + " FROM " + table_name + " WHERE x=? AND y=?;"
    var query_string := "SELECT " + type + " FROM " + table_name +" WHERE x= " + str(block_x) + " AND y=" + str(block_y) + ";"
    var condition := "x=" + str(block_x) + " AND y=" + str(block_y)

    db.open_db()
    # db.query_with_bindings(query_string, bindings)
    db.query(query_string)
    if db.query_result[0][type] != null:
        db.update_rows(table_name, condition, {type:null})
        db.close_db()
        return true

    db.close_db()
    return false

func add_cell(block_x: int, block_y: int) -> bool:
    var table_name := "field_blocks"

    var query_string := "SELECT * FROM " + table_name +" WHERE x= " + str(block_x) + " AND y=" + str(block_y) + ";"
    var bindings := [block_x, block_y]

    db.open_db()
    db.query(query_string)
    if db.query_result_by_reference.size() != 0:
        db.close_db()
        return false
    
    db.insert_row(table_name, {"x":block_x,"y":block_y})
    db.close_db()
    return true

func get_resource(block_x: int, block_y: int, type: String) -> Resource:
    var table_name := "field_blocks"

    var query_string := "SELECT " + type + " FROM " + table_name + " WHERE x=" +str(block_x)+ " AND y=" +str(block_y)+ ";"

    db.open_db()
    db.query(query_string)
    var resource_name = db.query_result[0][type]
    db.close_db()

    if resource_name == null:
        return null

    return static_resources[type][resource_name]
