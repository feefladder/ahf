extends Node
class_name Initializer

var db
var database

func init_db() -> bool:
    database = get_parent()
    db = database.db
    db.open_db()
    # tables for the field
    database.default_field = _init_field_table() # add farm table in a similar way whenever necessary
    var success: bool = _init_field_blocks_table()
    # tables for buying/selling
    success = _init_livestock_table() and success
    success = _init_household_table() and success
    success = _init_family_table() and success
    success = _init_school_table() and success
    success = _init_labour_table() and success
    success = _init_asset_table() and success
    success = _init_upgrades_table() and success
    # summary tables
    db.create_table("events",{
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "year":{
            "data_type":"int",
            "not_null":true,
            "default":database.year
        },
        "event":{
            "data_type":"text",
        }
    })
    success = _init_crop_sum_table() and success
    success = _init_asset_sum_table() and success
    success = _init_livestock_sum_table() and success
    db.close_db()

    return success

const blocklist := [
    "Reference",
    "Resource",
    "resource_local_to_scene",
    "resource_path",
    "script",
    "Script Variables",
]

const COL_TYPES := {
    TYPE_BOOL : "int",
    TYPE_INT : "int",
    TYPE_REAL : "real",
    TYPE_STRING: "text",
    TYPE_NODE_PATH: "text",
    TYPE_RAW_ARRAY: "blob",
    # TYPE_OBJECT: "blob"
}

const MCOL_TYPES := {
    TYPE_VECTOR2:["x","y"],
    TYPE_RECT2:["end", "position", "size"],
    TYPE_VECTOR3:["x","y","z"],
    TYPE_PLANE:["d","normal","x","y","z"],
    TYPE_QUAT:["w","x","y","z"],
    TYPE_AABB:["end","position","size"],
    TYPE_BASIS:["x","y","z"],
    TYPE_TRANSFORM:["baisis","origin"],
    TYPE_COLOR:["r","g","b","a"],
}

# const ARRAY_TYPES := {
#     TYPE_ARRAY : TYPE_OBJECT,
#     TYPE_INT_ARRAY : TYPE_INT,
#     TYPE_REAL_ARRAY : TYPE_REAL,
#     TYPE_STRING_ARRAY : TYPE_STRING,
#     TYPE_VECTOR2_ARRAY : TYPE_VECTOR2,
#     TYPE_VECTOR3_ARRAY : TYPE_VECTOR3,
#     TYPE_COLOR_ARRAY : TYPE_COLOR,
# }

func _on_resources_loaded(which: String, resources: Array) -> void:
    # add a generic table with years and the quantitative values of member variables
    if which == database.RESOURCE_TABLES:
        db.open_db()
        for resource in resources:
            if not resource.get_class() in database.resource_tables:
                if not create_table_from_resource(resource, {
                    "year":{
                        "data_type":"int",
                        "not_null":true,
                        "default":database.year
                    },
                    "field":{
                        "data_type":"int",
                        "not_null":true,
                        "default":database.default_field
                    }
                    # x and y coords if per-block fertility
                }):
                    print_debug("Could not create table for: ", resource, resource.get_class())
                    continue
            if not insert_row_from_resource(resource,{"year":database.year,"field":database.default_field}):
                print_debug("Could not populate table for: ", resource, resource.get_class())
        db.close_db()

func create_table_from_resource(resource: Resource, extra_cols: Dictionary ={}, pk_name: String ="id") -> bool:
    database.resource_tables.append(resource.get_class())
    var table_dict = extra_cols
    table_dict[pk_name] = {
        "data_type":"int",
        "primary_key":true,
        "auto_increment":true,
    }
    var f = funcref(self, "_add_col")
    _add_cols_recursive(table_dict, resource, f)
    return db.create_table(resource.get_class(),table_dict)

func insert_row_from_resource(resource: Resource, extra_cols: Dictionary = {}) -> int:
    var row_dict = extra_cols
    var f = funcref(self, "_populate_col")
    _add_cols_recursive(row_dict, resource, f)
    if db.insert_row(resource.get_class(), row_dict):
        return db.last_insert_rowid
    else:
        return 0

func _add_col(table_dict: Dictionary, col_name: String, thing) -> void:
    table_dict['"'+col_name+'"'] = {
        "data_type": COL_TYPES[typeof(thing)],
        "not_null":true,
    }

func _populate_col(row_dict: Dictionary, col_name: String, value) -> void:
    row_dict['"'+col_name+'"'] = value

func _add_cols_recursive(table_dict: Dictionary, resource: Resource, f: FuncRef) -> void:
    for p_dict in resource.get_property_list():
        if p_dict["name"] in blocklist:
            continue
        var p_obj = resource.get(p_dict["name"])
        if p_dict["type"] in COL_TYPES:
            f.call_func(table_dict, p_dict["name"], p_obj)
        elif p_dict["type"] in MCOL_TYPES:
            _add_mcol_recursive(table_dict, p_dict["name"], f, p_obj)
        else:
            print_debug("could not do anything with ",p_dict) #TODO automatic creation of extra tables etc

func _add_mcol_recursive(table_dict: Dictionary, name_prefix: String, f: FuncRef, thing, delim:String =".") -> void:
    match typeof(thing):
        TYPE_VECTOR2:
            f.call_func(table_dict, name_prefix+delim+"x", thing.x)
            f.call_func(table_dict, name_prefix+delim+"y", thing.y)
        TYPE_RECT2:
            _add_mcol_recursive(table_dict, name_prefix+delim+"end", f, thing.end)
            _add_mcol_recursive(table_dict, name_prefix+delim+"position", f, thing.position)
            _add_mcol_recursive(table_dict, name_prefix+delim+"size", f, thing.size)
        TYPE_VECTOR3:
            f.call_func(table_dict, name_prefix+delim+"x", thing.x)
            f.call_func(table_dict, name_prefix+delim+"y", thing.y)
            f.call_func(table_dict, name_prefix+delim+"z", thing.z)
        TYPE_PLANE:
            _add_mcol_recursive(table_dict, name_prefix+delim+"normal", f, thing.normal)
            f.call_func(table_dict, name_prefix+delim+"d", thing.d)
            f.call_func(table_dict, name_prefix+delim+"x", thing.x)
            f.call_func(table_dict, name_prefix+delim+"y", thing.y)
            f.call_func(table_dict, name_prefix+delim+"z", thing.z)
        TYPE_QUAT:
            f.call_func(table_dict, name_prefix+delim+"w", thing.w)
            f.call_func(table_dict, name_prefix+delim+"x", thing.x)
            f.call_func(table_dict, name_prefix+delim+"y", thing.y)
            f.call_func(table_dict, name_prefix+delim+"z", thing.z)
        TYPE_AABB:
            _add_mcol_recursive(table_dict, name_prefix+delim+"end", f, thing.end)
            _add_mcol_recursive(table_dict, name_prefix+delim+"position", f, thing.position)
            _add_mcol_recursive(table_dict, name_prefix+delim+"size", f, thing.size)
        TYPE_BASIS:
            _add_mcol_recursive(table_dict, name_prefix+delim+"x", f, thing.x)
            _add_mcol_recursive(table_dict, name_prefix+delim+"y", f, thing.y)
            _add_mcol_recursive(table_dict, name_prefix+delim+"z", f, thing.z)
        TYPE_TRANSFORM:
            _add_mcol_recursive(table_dict, name_prefix+delim+"basis", f, thing.basis)
            _add_mcol_recursive(table_dict, name_prefix+delim+"origin", f, thing.origin)
        TYPE_COLOR:
            f.call_func(table_dict, name_prefix+delim+"r", thing.r)
            f.call_func(table_dict, name_prefix+delim+"g", thing.g)
            f.call_func(table_dict, name_prefix+delim+"b", thing.b)
            f.call_func(table_dict, name_prefix+delim+"a", thing.a)
        _:
            print_debug("could not do anything with ",thing) #TODO automatic creation of extra tables etc

func _init_field_table() -> int:
    var table_name : String = database.FIELD_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "year":{
            "data_type":"int",
            "not_null":true,
            "default":database.year
        },
        "water_supply":{
            "data_type":"text",
        },
        }
    db.create_table(table_name,table_dict)
    db.query("INSERT INTO "+table_name+" DEFAULT VALUES;")
    db.query("SELECT id FROM "+table_name)
    return db.query_result[0]["id"]

func _init_fertility_table() -> bool:
    var table_name : String = database.FERTILITY_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "year":{
            "data_type":"int",
            "not_null":true,
        },
        "field":{
            "data_type":"int",
            "foreign_key":database.FIELD_TABLE+".id",
            "not_null":true,
        },
        "nutrient_status":{
            "data_type":"real",
            "not_null":true,
        },
        "soil_structure":{
            "data_type":"real",
            "not_null":true,
        },
        "erosion_rate":{
            "data_type":"real",
            "not_null":true,
        },
        "salinity":{
            "data_type":"real",
            "not_null":true,
        }
        }
    return db.create_table(table_name,table_dict)


func _init_field_blocks_table() -> bool:
    var table_name : String = database.FBLOCK_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "field":{
            "data_type":"int",
            "foreign_key":database.FIELD_TABLE+".id",
            "not_null":true
        },
        "year":{
            "data_type":"int",
            "not_null":true,
        },
        "x":{
            "data_type":"int",
            "not_null":true,
        },
        "y":{
            "data_type":"int",
            "not_null":true,
        },
       }
    for col in database.field_cols:
        table_dict[col] = {"data_type":"text"}
    return db.create_table(table_name,table_dict)

func _init_livestock_table() -> bool:
    var table_name : String = database.LIVESTOCK_TABLE
    var table_dict = {
        "id":{ # because it is uniqe_int_item
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "year_bought":{
            "data_type":"int",
            "not_null":true,
        },
        "year_sold":{
            "data_type":"int",
        },
        "name":{
            "data_type":"text",
            "not_null":true,
        },
        }
    return db.create_table(table_name,table_dict)

func _init_family_table() -> bool:
    var table_name : String = database.FAMILY_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "name":{
            "data_type":"text",
            "not_null":true,
        },
        "year":{
            "data_type":"int",
            "not_null":true,
        },
        "on_farm":{
            "data_type":"int",
            "not_null":true,
            "default":true,
        },
        "age":{
            "data_type":"int",
            "not_null":true,
        },
        } # all other values such as labour etc are in a Resource
    return db.create_table(table_name,table_dict)


func _init_household_table() -> bool:
    var table_name : String = database.HOUSEHOLD_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "name":{
            "data_type":"text",
            "not_null":true,
        },
        "year":{
            "data_type":"int",
            "not_null":true,
        },
        "amount":{
            "data_type":"int",
            "not_null":true,
        },
        } # all other values such as labour etc are in a Resource
    return db.create_table(table_name,table_dict)

func _init_school_table() -> bool:
    var table_name = database.SCHOOL_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "id_person":{
            "data_type":"int",
            "foreign_key":database.FAMILY_TABLE+".id",
            "not_null":true,
        },
        "id_school":{
            "data_type":"int",
            "foreign_key":database.HOUSEHOLD_TABLE+".id",
            "not_null":true,
        },
        "year":{
            "data_type":"int",
            "not_null":true,
        },
        "years_went":{
            "data_type":"int",
            "not_null":true,
            "default":0
        }
    }
    return db.create_table(table_name,table_dict)

func _init_asset_table() -> bool:
    # actually generic numeric/int item
    var table_name : String = database.ASSET_TABLE
    var table_dict = {
        "id":{ # compatible with "generic_item"
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "year":{
            "data_type":"int",
            "not_null":true,
        },
        "name":{
            "data_type":"text",
            "not_null":true,
        },
        "amount":{
            "data_type":"real",
            "not_null":true,
            "default":0,
        },
        }
    return db.create_table(table_name,table_dict)

func _init_labour_table() -> bool:
    var table_name : String = database.LABOUR_TABLE
    var table_dict = {
        "id":{ #generic_item table
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "year":{
            "data_type":"int",
            "not_null":true,
        },
        "name":{
            "data_type":"text",
            "not_null":true,
        },
        "amount":{
            "data_type":"int",
            "not_null":true,
        },
    }
    return db.create_table(table_name,table_dict)

func _init_upgrades_table() -> bool:
    var table_name : String = database.UPGRADE_TABLE
    var table_dict = {
        "id":{ # also unique_int_item table
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "name":{
            "data_type":"text",
            "not_null":true,
        },
        "year_bought":{
            "data_type":"int",
            "not_null":true,
        },
        "upgrades":{
            "data_type":"int",
            "not_null":true,
            "default":0,
        },
        }
    return db.create_table(table_name,table_dict)

func _init_crop_sum_table() -> bool:
    var table_name = database.CROP_SUM_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "year":{
            "data_type":"int",
            "not_null":true,
        },
        "crop":{
            "data_type":"text",
            "not_null":true,
        },
        "yield":{
            "data_type":"real",
            "not_null":true,
        },
    }
    return db.create_table(table_name,table_dict)

func _init_asset_sum_table() -> bool:
    var table_name = database.ASSET_SUM_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "year":{
            "data_type":"int",
            "not_null":true,
        },
        "name":{
            "data_type":"text",
            "not_null":true,
        }
    }
    return db.create_table(table_name,table_dict)

func _init_livestock_sum_table() -> bool:
    var table_name = database.LIV_SUM_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "year":{
            "data_type":"int",
            "not_null":true,
        },
        "name":{
            "data_type":"text",
            "not_null":true,
        }
    }
    return db.create_table(table_name,table_dict)
