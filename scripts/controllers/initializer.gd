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
    success = _init_asset_table() and success
    success = _init_buyresource_table() and success
    success = _init_buy_sell_table() and success
    success = _init_livestock_table() and success
    success = _init_household_table() and success
    success = _init_family_table() and success
    success = _init_school_table() and success
    success = _init_labour_table() and success
    
    success = _init_upgrades_table() and success
    # table for end-of-year events
    success = db.create_table("events",{
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
    }) and success
    # summary tables
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

func _init_buyresource_table() -> bool:
    # create a table with all resources we can buy, so end-of-year calculations on assets
    # are easier (they can be done with a join on the BUY_SELL_TABLE)
    var table_dict = {
        "id":{ # because it is uniqe_int_item
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "name":{
            "data_type":"text",
            "not_null":true,
        },
        "unit_price":{
            "data_type":"real",
            "not_null":true,
        },
        "unit_labour":{
            "data_type":"real",
            "not_null":true,
        },
    }
    return db.create_table(database.BUYRESOURCE_TABLE, table_dict)
    

func _init_buy_sell_table() -> bool:
    var table_dict = {
        "id":{
            "data_type":"int",
            "not_null":true,
            "primary_key":true,
            "auto_increment":true,
        },
        "year":{
            "data_type":"int",
            "not_null":true,
        },
        "id_resource":{
            "data_type":"int",
            "foreign_key":database.BUYRESOURCE_TABLE+".id",
            "not_null":true,
        },
        "amount":{
            "data_type":"int",
            "not_null":true,
        },
    }
    return db.create_table(database.BUY_SELL_TABLE, table_dict)

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
        "name":{
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
        },
        "amount":{
            "data_type":"int",
            "not_null":true,
        },
        "d_money":{
            "data_type":"real",
            "not_null":true,
        },
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
