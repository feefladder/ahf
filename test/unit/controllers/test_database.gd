extends GutTest

class TestLoadingAndSignals:
    extends GutTest

    var database: Database
    var measure: MeasureResource
    var crop_01: CropResource
    var crop_02: CropResource

    func before_each():
        measure = load("res://test/unit/resources/measures/01_terraces.tres")
        crop_01 = load("res://test/unit/resources/crops/irish_potato.tres")
        crop_02 = load("res://test/unit/resources/crops/maize.tres")
        database = partial_double(Database).new()
        database.base_path = "res://test/unit/resources/"
        database.fields_to_paths = {
            "crop_resource":     "crops/",
            "measures_resource": "measures/"
        }
        watch_signals(database)
        # add_child(database)

    func test___load_resources_measure():
        assert_eq(database.fields_to_paths["measures_resource"], "measures/")
        assert_eq(database._load_resources("measures_resource"),[measure])

    func test__load_resources_crops():
        assert_eq(database._load_resources("crop_resource"), [crop_01, crop_02 ])
    
    func test_static_resources():
        # add_child(database)
        assert_eq(database.fields_to_paths["crop_resource"], "crops/")
        assert_eq_deep(database.static_resources, {})
        assert_eq(database._load_resources("crop_resource"),[crop_01,crop_02])
        gut.p(database.static_resources)
        assert_eq(database.types_to_fields[typeof(crop_01)], "crop")
        assert_eq_deep(
            database.static_resources,
            {"crop":
                {crop_01.resource_name : 
                    crop_01, 
                crop_02.resource_name:
                    crop_02
                }
            })

    func test_signal_measure():
        database.fields_to_paths = {"measures": "measures/"}
        add_child_autoqfree(database)
        assert_signal_emitted_with_parameters(database, "resources_loaded", ["measures", [measure]])

    func test_signal_crops():
        database.fields_to_paths = {"crops": "crops/"}
        add_child_autofree(database)
        assert_signal_emitted_with_parameters(database, "resources_loaded", ["crops", [crop_01, crop_02]])

    func test_signal_both():
        database.fields_to_paths = {"measures": "measures/", "crops": "crops/"}
        add_child_autofree(database)
        assert_signal_emitted_with_parameters(database, "resources_loaded", ["measures", [measure]], 0)
        assert_signal_emitted_with_parameters(database, "resources_loaded", ["crops", [crop_01, crop_02]], 1)

    func test_signal_non_existent_folder():
        database.fields_to_paths = {"non_existent_folder": "non_existent_folder/"}
        add_child_autofree(database)
        assert_signal_emitted_with_parameters(database, "resources_loaded", ["non_existent_folder", []])

    func test_signal_no_resource_folder():
        # test a folder with no resource, but script files, should return empty
        database.fields_to_paths = {"family": "family/"}
        add_child_autofree(database)
        assert_signal_emitted_with_parameters(database, "resources_loaded", ["family", []])

class TestDatabaseSQL:
    extends GutTest

    var database: Database
    var table_name := "field_blocks"
    var row_dict := {
        # "block_id" : 0,
        "x" : 0,
        "y" : 0,
        "crop" : "maize",
        "structural_measure" : null
    }

    func before_each():
        database = partial_double(Database).new()
        self.add_child_autoqfree(database)
        database.db.verbosity_level = 0
        database.db.open_db()
        database.db.insert_row(table_name, row_dict)
        database.db.close_db()

    func after_each():
        database.db.open_db()
        database.db.delete_rows(table_name, "*")
        database.db.close_db()

    func test_database_write_if_empty():
        # there is already a crop at that cell: "maize" should fail and not update
        assert_false(database.write_if_empty(0,0,"crop", "beans"))

        database.db.open_db()
        database.db.query("SELECT crop FROM field_blocks WHERE x=0 AND y=0")
        assert_eq(database.db.query_result.size(), 1)
        assert_eq(database.db.query_result[0]["crop"], "maize")
        database.db.close_db()

        # There is no measure yet, so we can actually update the row.
        assert_true(database.write_if_empty(0,0,"structural_measure", "terraces"))

        database.db.open_db()
        database.db.query("SELECT structural_measure FROM field_blocks WHERE x=0 AND y=0")
        assert_eq(database.db.query_result.size(), 1)
        assert_eq(database.db.query_result[0]["structural_measure"], "terraces")
        database.db.close_db()
    
    func test_database_empty_block_type():
        #true: crop is there
        assert_true(database.empty_block_type(0,0,"crop"))
        database.db.open_db()
        database.db.query("SELECT crop FROM field_blocks WHERE x=0 AND y=0")
        assert_eq_deep([{"crop":null}], database.db.query_result)
        database.db.close_db()
        #false: there is no crop anymore
        assert_false(database.empty_block_type(0,0,"crop"))

    func test_database_add_block():
        #false, cell already exists
        assert_false(database.add_block(0,0))

        database.db.open_db()
        database.db.query("SELECT * FROM field_blocks WHERE x=0 and y=0")
        assert_eq_deep(database.db.query_result[0]["crop"], "maize")
        assert_eq(database.db.query_result.size(), 1)
        database.db.close_db()


        #true, cell is not in database yet
        assert_true(database.add_block(1,0))

        database.db.open_db()
        database.db.query("SELECT * FROM field_blocks WHERE x=0 and y=0")
        assert_eq(database.db.query_result.size(), 1)
        database.db.close_db()

class TestDatabaseGetCellResources:
    extends GutTest

    var database: Database
    var measure: MeasureResource
    var crop_01: CropResource
    var crop_02: CropResource

    func before_each():
        measure = load("res://test/unit/resources/measures/01_terraces.tres")
        crop_01 = load("res://test/unit/resources/crops/irish_potato.tres")
        crop_02 = load("res://test/unit/resources/crops/maize.tres")
        database = partial_double(Database).new()
        database.base_path = "res://test/unit/resources/"
        database.fields_to_paths = {}
        self.add_child_autoqfree(database)
        database.db.verbosity_level = 2
        database.add_block(0,0)
        database.add_block(0,1)
        database.add_block(1,0)
        database.add_block(1,1)
    
    func after_each():
        database.db.open_db()
        database.db.delete_rows("field_blocks", "*")
        database.db.close_db()
    
    func test_get_crop():
        # the idea of this test is to ask the database to get the corresponding resource
        # (crop) that belongs to a table cell.

        database.write_if_empty(0,0, "crop", crop_02.resource_name)
        assert_eq(database.get_resource(0,0,"crop"), crop_02)

