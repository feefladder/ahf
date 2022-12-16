extends GutTest

class TestLoadingAndSignals:
    extends GutTest

    var db: Database
    var measure: StructuralMeasureResource
    var crop_01: CropResource
    var crop_02: CropResource

    func before_each():
        measure = load("res://test/unit/resources/structural_measures/01_terraces.tres")
        crop_01 = load("res://test/unit/resources/crops/irish_potato.tres")
        crop_02 = load("res://test/unit/resources/crops/maize.tres")
        db = partial_double(Database).new()
        db.base_path = "res://test/unit/resources/"
        db.fields_to_paths = {
            "crop":     "crops/",
            "structural_measure": "structural_measures/"
        }
        watch_signals(db)
        # add_child(db)

    func test___load_resources_measure():
        assert_eq(db.fields_to_paths["structural_measure"], "structural_measures/")
        assert_eq(db._load_resources("structural_measure"),[measure])

    func test__load_resources_crops():
        var loaded_crops := db._load_resources("crop")
        for crop in [crop_01, crop_02]:
            assert_true(crop in loaded_crops)
    
    func test_static_resources():
        # add_child(db)
        assert_eq(db.fields_to_paths["crop"], "crops/")
        assert_eq_deep(db.static_resources, {})
        var loaded_crops = db._load_resources("crop")
        for crop in [crop_01, crop_02]:
            assert_true(crop in loaded_crops)
    
        gut.p(db.static_resources)
        # assert_eq(db.types_to_fields[typeof(crop_01)], "crop")
        assert_eq_deep(
            db.static_resources,
            {"crop":
                {crop_01.resource_name : 
                    crop_01, 
                crop_02.resource_name:
                    crop_02
                }
            })

    func test_signal_measure():
        db.fields_to_paths = {"structural_measure": "structural_measures/"}
        add_child_autoqfree(db)
        assert_signal_emitted_with_parameters(db, "resources_loaded", ["structural_measure", [measure]])

    func test_signal_crops():
        db.fields_to_paths = {"crop": "crops/"}
        add_child_autofree(db)
        # check ["crops", [crop_01, crop_02]] where the order of crops can be different
        var crop_resources :Array = get_signal_parameters(db, "resources_loaded")
        assert_eq(crop_resources[0], "crop")
        assert_eq(crop_resources[1].size(), 2)
        gut.p(crop_resources)
        assert_true(crop_01 in crop_resources[1])
        assert_true(crop_02 in crop_resources[1])

    func test_signal_both():
        add_child_autofree(db)
        assert_signal_emitted_with_parameters(db, "resources_loaded", ["structural_measure", [measure]], 1)

        var crop_resources :Array = get_signal_parameters(db, "resources_loaded", 0)
        # check ["crops", [crop_01, crop_02]] where the order of crops can be different
        assert_eq(crop_resources[0], "crop")
        assert_eq(crop_resources[1].size(), 2)
        assert_true(crop_01 in crop_resources[1])
        assert_true(crop_02 in crop_resources[1])
        # assert_signal_emitted_with_parameters(db, "resources_loaded", ["crops", [crop_01, crop_02]], 1)

    func test_signal_non_existent_folder():
        db.fields_to_paths = {"non_existent_folder": "non_existent_folder/"}
        add_child_autofree(db)
        assert_signal_emitted_with_parameters(db, "resources_loaded", ["non_existent_folder", []])

    func test_signal_no_resource_folder():
        # test a folder with no resource, but script files, should return empty
        db.fields_to_paths = {"no_resources": "i_do_not_have_resources_only_scripts/"}
        add_child_autofree(db)
        assert_signal_emitted_with_parameters(db, "resources_loaded", ["no_resources", []])

class TestDatabaseEndOfYear:

    extends GutTest

    var db: Database
    var table_name := "field_blocks"

    func before_each():
        db = partial_double(Database).new()
        stub(db, "_load_resources").to_do_nothing()
        add_child_autoqfree(db)
        db.db.verbosity_level = 0

    func test_eoy_fblock():
        assert_true(db.add_block(0,0))
        assert_true(db.write_block_if_empty(0,0,"crop","maize"))
        assert_true(db.write_block_if_empty(0,0,"structural_measure","terraces"))

        #check if table has been correctly generated
        db.db.open_db()
        db.db.query("SELECT id, crop, structural_measure, year FROM "+db.FBLOCK_TABLE)
        assert_eq_deep(db.db.query_result,[{"id":1,"crop":"maize","structural_measure":"terraces","year":1}])
        db.db.close_db()

        # increase year
        assert_true(db.increase_year(db.FBLOCK_TABLE))

        db.db.open_db()
        # check if id has remained the same
        db.db.query("SELECT id FROM "+db.FBLOCK_TABLE+" WHERE year=2")
        assert_eq(db.db.query_result.size(), 1)
        assert_eq_deep(db.db.query_result,[{"id":1}])
        # check if current year id is incremented
        db.db.query("SELECT id FROM "+db.FBLOCK_TABLE+" WHERE year=1")
        assert_eq_deep(db.db.query_result,[{"id":2}])
        # check if columns are the same
        var cols := ["crop","structural_measure","measure_improvement","irrigation"]
        var row_y1 = db.db.select_rows(db.FBLOCK_TABLE,"year=1",cols)
        var row_y2 = db.db.select_rows(db.FBLOCK_TABLE,"year=2",cols)
        assert_eq_deep(row_y1, row_y2)
        db.db.close_db()

class TestDatabaseUniqueIntItems:
    # class for testing unique int items:
    # livestock
    # add others
    extends GutTest

    var db: Database

    func before_each():
        db = partial_double(Database).new()
        stub(db, "_load_resources").to_do_nothing()
        add_child_autoqfree(db)
        db.db.verbosity_level = 0

    func test_db_livestock():
        var items: Array = []
        items.append(db.add_unique_int_item("cow", db.LIVESTOCK_TABLE))
        assert_eq(items[0], 1)
        items.append(db.add_unique_int_item("cow", db.LIVESTOCK_TABLE))
        assert_eq(items[1], 2)
        items.append(db.add_unique_int_item("chicken", db.LIVESTOCK_TABLE))
        assert_eq(items[2], 3)
        db.db.open_db()
        db.db.query("SELECT name FROM "+db.LIVESTOCK_TABLE+" WHERE name='cow'")
        assert_eq_deep(db.db.query_result, [{"name":"cow"},{"name":"cow"}])
        db.db.query("SELECT name, year_bought FROM "+db.LIVESTOCK_TABLE+" WHERE name='cow'")
        assert_eq_deep(db.db.query_result,[{"name":"cow","year_bought":1},{"name":"cow","year_bought":1}])
        db.db.close_db()

        assert_eq_deep(
            db.get_unique_int_items("cow", db.LIVESTOCK_TABLE),
            [{"id":items[0],"name":"cow","year_bought":1},{"id":items[1],"name":"cow","year_bought":1}]
        )

class TestDatabaseGenericIntItems:
    extends GutTest

    var db: Database

    func before_each():
        db = partial_double(Database).new()
        stub(db, "_load_resources").to_do_nothing()
        add_child_autoqfree(db)
        db.db.verbosity_level = 0

    func test_generic_add_item():
        assert_eq(db.add_generic_item("labourer", db.LABOUR_TABLE, 3),1)
        assert_eq(db.get_generic_amount("labourer", db.LABOUR_TABLE), 3)
        db.db.open_db()
        assert_true(db.db.query("SELECT * FROM "+db.LABOUR_TABLE+";"))
        assert_eq_deep(db.db.query_result,[{"id":1,"name":"labourer","year":1,"amount":3}])
        db.db.close_db()

    func test_generic_change_item():
        assert_eq(db.add_generic_item("labourer", db.LABOUR_TABLE, 0),1)
        assert_eq(db.change_generic_item("labourer", db.LABOUR_TABLE, 12),12)
        db.db.open_db()
        assert_true(db.db.query("SELECT * FROM "+db.LABOUR_TABLE+";"))
        assert_eq_deep(db.db.query_result,[{"id":1,"name":"labourer","year":1,"amount":12}])
        db.db.close_db()
    

    func test_db_assets():
        assert_eq(db.add_generic_item("money", db.ASSET_TABLE, 1000.0),1)
        assert_eq(db.add_generic_item("used_labour", db.ASSET_TABLE, 0),2)
        assert_eq(db.get_generic_amount("money", db.ASSET_TABLE),1000.0)
        assert_eq(db.get_generic_amount("used_labour", db.ASSET_TABLE),0.0)
        assert_eq(db.change_generic_item("money", db.ASSET_TABLE, 500), 1500.0)
        assert_eq(db.change_generic_item("money", db.ASSET_TABLE, -750), 750.0)

    func test_generic_changed_item():
        assert_eq(db.add_generic_item("labourer", db.LABOUR_TABLE, 0),1)
        db.year+=1
        assert_eq(db.add_generic_item("labourer", db.LABOUR_TABLE, 5),2)
        db.db.open_db()
        db.db.query("SELECT * FROM "+db.LABOUR_TABLE)
        assert_eq_deep(db.db.query_result,
            [
                {"id":1,"name":"labourer","year":1,"amount":0},
                {"id":2,"name":"labourer","year":2,"amount":5}
            ])
        db.db.close_db()
        assert_eq_deep(
            db.get_generic_changed_items(db.LABOUR_TABLE),
            [{"name":"labourer","amount":5,"d_amount":5}]
        )
    
    func test_generic_unchanged_item():
        assert_eq(db.add_generic_item("labourer", db.LABOUR_TABLE, 5),1)
        db.year+=1
        assert_eq(db.add_generic_item("labourer", db.LABOUR_TABLE, 5),2)
        db.db.open_db()
        db.db.query("SELECT * FROM "+db.LABOUR_TABLE)
        assert_eq_deep(db.db.query_result,
            [
                {"id":1,"name":"labourer","year":1,"amount":5},
                {"id":2,"name":"labourer","year":2,"amount":5}
            ])
        db.db.close_db()
        assert_eq_deep(
            db.get_generic_changed_items(db.LABOUR_TABLE),
            []
        )

    func test_generic_changed_items():
        assert_eq(db.add_generic_item("labourer", db.LABOUR_TABLE, 0),1)
        assert_eq(db.add_generic_item("off farm job", db.LABOUR_TABLE, 0),2)
        db.year+=1
        assert_eq(db.add_generic_item("labourer", db.LABOUR_TABLE, 5),3)
        assert_eq(db.add_generic_item("off farm job", db.LABOUR_TABLE, 1),4)
        db.db.open_db()
        db.db.query("SELECT * FROM "+db.LABOUR_TABLE)
        assert_eq_deep(db.db.query_result,
            [
                {"id":1,"name":"labourer","year":1,"amount":0},
                {"id":2,"name":"off farm job","year":1,"amount":0},
                {"id":3,"name":"labourer","year":2,"amount":5},
                {"id":4,"name":"off farm job","year":2,"amount":1}
            ])
        db.db.close_db()
        assert_eq_deep(
            db.get_generic_changed_items(db.LABOUR_TABLE),
            [
                {"name":"labourer","amount":5,"d_amount":5},
                {"name":"off farm job","amount":1,"d_amount":1}
            ]
        )
    
    func test_generic_changed_items_one_unchanged():
        assert_eq(db.add_generic_item("labourer", db.LABOUR_TABLE, 0),1)
        assert_eq(db.add_generic_item("off farm job", db.LABOUR_TABLE, 0),2)
        db.year+=1
        assert_eq(db.add_generic_item("labourer", db.LABOUR_TABLE, 5),3)
        assert_eq(db.add_generic_item("off farm job", db.LABOUR_TABLE, 0),4)
        db.db.open_db()
        db.db.query("SELECT * FROM "+db.LABOUR_TABLE)
        assert_eq_deep(db.db.query_result,
            [
                {"id":1,"name":"labourer","year":1,"amount":0},
                {"id":2,"name":"off farm job","year":1,"amount":0},
                {"id":3,"name":"labourer","year":2,"amount":5},
                {"id":4,"name":"off farm job","year":2,"amount":0}
            ])
        db.db.close_db()
        assert_eq_deep(
            db.get_generic_changed_items(db.LABOUR_TABLE),
            [
                {"name":"labourer","amount":5,"d_amount":5}, # off farm job unchanged
            ]
        )

class TestDatabaseSchool:
    extends GutTest

    var db: Database
    var primary_school: SchoolResource
    var sec_school: SchoolResource
    var adal: PersonResource
    var id_adal:int
    var id_primary: int
    var id_sec: int

    func before_each():
        primary_school = load("res://test/unit/resources/household/00_primary_school.tres")
        sec_school = load("res://test/unit/resources/household/01_seconday_school.tres")
        adal=load("res://test/unit/resources/family/son.tres")
        db = partial_double(Database).new()
        db.base_path = "res://test/unit/resources/"
        db.fields_to_paths = {
            db.FAMILY_TABLE:     "family/",
            db.HOUSEHOLD_TABLE: "household/"
        }
        add_child_autoqfree(db)
        db.db.verbosity_level = 0
        assert_true(db.add_family([adal]))
        assert_eq(db.add_generic_item(primary_school.resource_name, db.HOUSEHOLD_TABLE, 0),1)
        assert_eq(db.add_generic_item(sec_school.resource_name, db.HOUSEHOLD_TABLE, 0),2)
        id_primary = db.get_id(primary_school.resource_name, db.HOUSEHOLD_TABLE)
        id_sec = db.get_id(sec_school.resource_name, db.HOUSEHOLD_TABLE)
        db.db.open_db()
        assert_true(db.db.query("SELECT id FROM "+db.FAMILY_TABLE+" WHERE name='"+adal.resource_name+"';"))
        id_adal = db.db.query_result[0]["id"]
        db.db.close_db()

    func test_eligible_no_school():
        # db.db.open_db()
        # assert_true(db.db.query("SELECT id, name FROM "+db.FAMILY_TABLE+";"))
        # assert_eq_deep(db.db.query_result,
        #     [{"name":"Adal","id":1}]
        # )
        # db.db.close_db()
        assert_eq_deep(
            db.get_eligible_children(primary_school),
            [{"name":"Adal","years_went":null,"id":1,"age":8}]
        )
    
    func test_eligible_school():
        db.db.open_db()
        db.db.insert_row(db.SCHOOL_TABLE, {
            "id_school":id_primary,
            "id_person":id_adal,
            "year":db.year})
        db.db.close_db()
        assert_eq_deep(
            db.get_eligible_children(primary_school),
            [{"name":"Adal","years_went":0,"id":1,"age":8}]
        )
    
    func test_not_eligible_school_finished():
        db.db.open_db()
        db.db.insert_row(db.SCHOOL_TABLE, {
            "id_school":id_primary,
            "id_person":id_adal,
            "years_went":primary_school.years_till_finished,
            "year":db.year})
        db.db.close_db()
        assert_eq_deep(
            db.get_eligible_children(primary_school),
            []
        )
    
    func test_not_eligible_too_old():
        db.db.open_db()
        db.db.update_rows(db.FAMILY_TABLE,"1=1",{"age":13})
        db.db.close_db()
        assert_eq_deep(
            db.get_eligible_children(primary_school),
            []
        )

    func test_not_eligible_no_previous():
        assert_eq_deep(
            db.get_eligible_children(sec_school),
            []
        )
    
    func test_not_eligible_previous_not_finished():
        db.db.open_db()
        db.db.insert_row(db.SCHOOL_TABLE, {
            "id_school":id_primary,
            "id_person":id_adal,
            "years_went":1,
            "year":db.year
        })
        db.db.close_db()
        assert_eq_deep(
            db.get_eligible_children(sec_school),
            []
        )

    func test_eligible_previous_finished():
        db.db.open_db()
        db.db.insert_row(db.SCHOOL_TABLE, {
            "id_school":id_primary,
            "id_person":id_adal,
            "years_went":primary_school.years_till_finished,
            "year":db.year
        })
        db.db.close_db()
        assert_eq_deep(
            db.get_eligible_children(sec_school),
            [{"name":"Adal","years_went":null,"id":1,"age":8}]
        )

    func test_send_child_no_school():
        db.db.open_db()
        assert_true(db.db.query("SELECT * FROM "+db.SCHOOL_TABLE))
        assert_eq_deep(
            db.db.query_result,
            []
        )
        db.db.close_db()

        assert_true(db.send_child_to_school(1, primary_school))
        db.db.open_db()
        assert_true(db.db.query("SELECT * FROM "+db.SCHOOL_TABLE))
        assert_eq_deep(
            db.db.query_result,
            [{"id":1,"id_school":1,"id_person":1,"year":1,"years_went":1}]
        )
        db.db.close_db()

    func test_send_child_prev_school():
        db.db.open_db()
        db.db.insert_row(db.SCHOOL_TABLE, {
            "id_school":id_primary,
            "id_person":id_adal,
            "years_went":1,
            "year":db.year
        })
        db.db.close_db()
        assert_true(db.send_child_to_school(1, primary_school))
        db.db.open_db()
        assert_true(db.db.query("SELECT * FROM "+db.SCHOOL_TABLE))
        assert_eq_deep(
            db.db.query_result,
            [{"id":1,"id_school":1,"id_person":1,"year":1,"years_went":2}]
        )
        db.db.close_db()
    
    func test_children_going_no_prev():
        assert_true(db.send_child_to_school(1,primary_school))
        assert_eq_deep(
            db.get_children_going_to_school(primary_school),
            [{"name":"Adal","id":1}]
        )
    
    func test_children_going_prev():
        assert_true(db.send_child_to_school(1,primary_school))
        assert_true(db.increase_year(db.SCHOOL_TABLE))
        assert_true(db.increase_year(db.HOUSEHOLD_TABLE))
        assert_true(db.increase_year(db.FAMILY_TABLE))
        db.year +=1
        assert_true(db.send_child_to_school(1,primary_school))
        assert_eq_deep(
            db.get_children_going_to_school(primary_school),
            [{"name":"Adal","id":1}]
        )
    
    func test_children_not_going_no_prev():
        assert_eq_deep(
            db.get_children_going_to_school(primary_school),
            []
        )
    
    func test_children_not_going_prev():
        assert_true(db.send_child_to_school(1,primary_school))
        assert_true(db.increase_year(db.SCHOOL_TABLE))
        assert_true(db.increase_year(db.HOUSEHOLD_TABLE))
        assert_true(db.increase_year(db.FAMILY_TABLE))
        db.year +=1
        assert_eq_deep(
            db.get_children_going_to_school(primary_school),
            []
        )

class TestDatabaseFBlock:
    extends GutTest

    var db: Database
    var table_name := "field_blocks"
    var row_dict := {
        # "block_id" : 0,
        "x" : 0,
        "y" : 0,
        "year" : 1,
        "crop" : "maize",
        "structural_measure" : null,
        "field" : 1,
    }

    func before_each():
        db = partial_double(Database).new()
        db.base_path = "res://test/unit/resources/"
        db.fields_to_paths = {
            "crop":     "crops/",
            "structural_measure": "structural_measures/"
        }
        self.add_child_autoqfree(db)
        db.db.verbosity_level = 0
        db.db.open_db()
        db.db.insert_row(table_name, row_dict)
        db.db.close_db()

    func after_each():
        db.db.open_db()
        db.db.delete_rows(table_name, "*")
        db.db.close_db()

    func test_db_write_block_if_empty():
        # there is already a crop at that cell: "maize" should fail and not update
        assert_false(db.write_block_if_empty(0,0,"crop", "beans"))

        db.db.open_db()
        db.db.query("SELECT crop FROM field_blocks WHERE x=0 AND y=0")
        assert_eq(db.db.query_result.size(), 1)
        assert_eq(db.db.query_result[0]["crop"], "maize")
        db.db.close_db()

        # There is no measure yet, so we can actually update the row.
        assert_true(db.write_block_if_empty(0,0,"structural_measure", "terraces"))

        db.db.open_db()
        db.db.query("SELECT structural_measure FROM field_blocks WHERE x=0 AND y=0")
        assert_eq(db.db.query_result.size(), 1)
        assert_eq(db.db.query_result[0]["structural_measure"], "terraces")
        db.db.close_db()
    
    func test_db_empty_block_type():
        #true: crop is there
        assert_true(db.empty_block_type(0,0,"crop"))
        db.db.open_db()
        db.db.query("SELECT crop FROM field_blocks WHERE x=0 AND y=0")
        assert_eq_deep([{"crop":null}], db.db.query_result)
        db.db.close_db()
        #false: there is no crop anymore
        assert_false(db.empty_block_type(0,0,"crop"))

    func test_db_add_block():
        #false, cell already exists
        assert_false(db.add_block(0,0))

        db.db.open_db()
        db.db.query("SELECT * FROM field_blocks WHERE x=0 and y=0")
        gut.p(db.db.select_rows(table_name, "x=0 AND y=0",["year","crop"]))
        assert_eq_deep(db.db.query_result[0]["crop"], "maize")
        assert_eq(db.db.query_result.size(), 1)
        db.db.close_db()


        #true, cell is not in db yet
        assert_true(db.add_block(1,0))

        db.db.open_db()
        db.db.query("SELECT * FROM field_blocks WHERE x=0 and y=0")
        assert_eq(db.db.query_result.size(), 1)
        db.db.close_db()


class TestDatabaseFBlockResource:
    extends GutTest

    var db: Database
    var measure: StructuralMeasureResource
    var crop_01: CropResource
    var crop_02: CropResource

    func before_each():
        measure = load("res://test/unit/resources/structural_measures/01_terraces.tres")
        crop_01 = load("res://test/unit/resources/crops/irish_potato.tres")
        crop_02 = load("res://test/unit/resources/crops/maize.tres")
        db = partial_double(Database).new()
        db.base_path = "res://test/unit/resources/"
        db.fields_to_paths = {
            "crop":     "crops/",
        }
        self.add_child_autoqfree(db)
        db.db.verbosity_level = 0
        assert_true(db.add_block(0,0))
        assert_true(db.add_block(0,1))
        assert_true(db.add_block(1,0))
        assert_true(db.add_block(1,1))
    
    func after_each():
        db.db.open_db()
        db.db.delete_rows("field_blocks", "*")
        db.db.close_db()
    
    func test_get_crop():
        # the idea of this test is to ask the db to get the corresponding resource
        # (crop) that belongs to a table cell.

        assert_true(db.write_block_if_empty(0,0, "crop", crop_02.resource_name))
        assert_eq(db.get_block_resource(0,0,"crop"), crop_02)

