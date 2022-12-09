extends Node
class_name Initializer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func init_db():
    get_parent().db.open_db()
    _init_field_table()
    _init_fertility_table()
    _init_field_blocks_table()
    _init_livestock_table()
    _init_family_table()
    _init_asset_table()
    _init_upgrades_table()
    get_parent().db.close_db()

func _init_field_table():
    var table_name : String = get_parent().FIELD_TABLE
    var table_dict = {
        "id_field":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
           },
        "water_supply":{
            "data_type":"text",
        }
        }
    get_parent().db.create_table(table_name,table_dict)
    get_parent().db.query("INSERT INTO "+table_name+" DEFAULT VALUES;")

func _init_fertility_table():
    var table_name : String = get_parent().FERTILITY_TABLE
    var table_dict = {
        "id_fert":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
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
    get_parent().db.create_table(table_name,table_dict)

func _init_field_blocks_table():
    var table_name : String = get_parent().FBLOCK_TABLE
    var table_dict = {
        "id_fblock":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
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
    get_parent().db.create_table(table_name,table_dict)

func _init_livestock_table():
    var table_name : String = get_parent().LIVESTOCK_TABLE
    var table_dict = {
        "id_livestock":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
           },
        "year_bought":{
            "data_type":"int",
            "not_null":true,
        },
        "type":{
            "data_type":"text",
            "not_null":true,
        },
        }
    get_parent().db.create_table(table_name,table_dict)

func _init_family_table():
    var table_name : String = get_parent().FAMILY_TABLE
    var table_dict = {
        "id_fam":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
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
        "primary_school_years":{
            "data_type":"int",
           },
        "secondary_school_years":{
            "data_type":"int",
           }
        } # all other values such as labour etc are in a Resource
    get_parent().db.create_table(table_name,table_dict)

func _init_asset_table():
    var table_name : String = get_parent().ASSET_TABLE
    var table_dict = {
        "id_asset":{
            "data_type":"int",
            "primary_key":true,
            "auto_increment":true,
           },
        "year":{
            "data_type":"int",
            "not_null":true,
           },
        "money":{
            "data_type":"int",
            "not_null":true,
            "default":0,
           },
        }
    get_parent().db.create_table(table_name,table_dict)

func _init_upgrades_table():
    var table_name : String = get_parent().UPGRADE_TABLE
    var table_dict = {
        "id_asset":{
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
    get_parent().db.create_table(table_name,table_dict)
