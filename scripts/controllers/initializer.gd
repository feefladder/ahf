extends Node
class_name Initializer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var db

func init_db() -> bool:
    db = get_parent().db
    db.open_db()
    get_parent().default_field = _init_field_table() # add farm table in a similar way whenever necessary
    var success: bool = _init_fertility_table()
    success = _init_field_blocks_table() && success
    success = _init_livestock_table() && success
    success = _init_household_table() && success
    success = _init_family_table() && success
    success = _init_school_table() && success
    success = _init_labour_table() && success
    success = _init_asset_table() && success
    success = _init_upgrades_table() && success
    db.close_db()

    return success


func _init_field_table() -> int:
    var table_name : String = get_parent().FIELD_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
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
    var table_name : String = get_parent().FERTILITY_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "field":{
            "data_type":"int",
            "foreign_key":get_parent().FIELD_TABLE+".id",
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
        }
    return db.create_table(table_name,table_dict)


func _init_field_blocks_table() -> bool:
    var table_name : String = get_parent().FBLOCK_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "field":{
            "data_type":"int",
            "foreign_key":get_parent().FIELD_TABLE+".id",
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
        "crop":{
            "data_type":"text"
        },
        "structural_measure":{
            "data_type":"text",
        },
        "measure_improvement":{
            "data_type":"text",
        },
        "irrigation":{
            "data_type":"text",
        },
        "fertilization":{
            "data_type":"text",
        },
       }
    return db.create_table(table_name,table_dict)

func _init_livestock_table() -> bool:
    var table_name : String = get_parent().LIVESTOCK_TABLE
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
    var table_name : String = get_parent().FAMILY_TABLE
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
    var table_name : String = get_parent().HOUSEHOLD_TABLE
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
    var table_name = get_parent().SCHOOL_TABLE
    var table_dict = {
        "id":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
        },
        "id_person":{
            "data_type":"int",
            "foreign_key":get_parent().FAMILY_TABLE+".id",
            "not_null":true,
        },
        "id_school":{
            "data_type":"int",
            "foreign_key":get_parent().HOUSEHOLD_TABLE+".id",
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
    var table_name : String = get_parent().ASSET_TABLE
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
    var table_name : String = get_parent().LABOUR_TABLE
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
    var table_name : String = get_parent().UPGRADE_TABLE
    var table_dict = {
        "id":{ # also unique_int_item table
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
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
