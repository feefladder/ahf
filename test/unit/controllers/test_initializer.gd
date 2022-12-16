extends GutTest

class TestTablesCreated:
    extends GutTest

    var database: Database
    var initializer: Initializer

    func before_each():
        # we need to create a database to be able to interface with SQL
        database = autoqfree(partial_double(Database).new())
        assert_true(database.obliterate_database())
        stub(database, "obliterate_database").to_do_nothing()
        # stub(database, "_exit_tree").to_do_nothing()
        # database.initializer.queue_free()
        initializer = autoqfree(partial_double(Initializer).new())
        database.initializer = initializer
        initializer.db = database.db
        database.add_child(initializer)
        add_child(database)

    func test_init_field_table():
        database.db.open_db()
        assert_eq(initializer._init_field_table(),1)
        assert_true(database.db.query("SELECT * FROM "+database.FIELD_TABLE))
        assert_eq_deep(database.db.query_result, [{"id":1,"water_supply":null, "year":1}])
        assert_true(database.db.drop_table(database.FIELD_TABLE))
        database.db.close_db()
    
    func test_init_fertility_table():
        database.db.open_db()
        var id_field: int = initializer._init_field_table()
        assert_true(initializer._init_fertility_table())
        assert_true(database.db.insert_row(database.FERTILITY_TABLE,{
                    "nutrient_status":0.5,
                    "soil_structure":0.5,
                    "erosion_rate":0.5,
                    "field":id_field,
                    "year":1,
            }))
        assert_true(database.db.drop_table(database.FERTILITY_TABLE))
        database.db.close_db()

    func test_init_field_blocks_table():
        database.db.open_db()
        assert_ne(initializer._init_field_table(),0)
        assert_true(initializer._init_field_blocks_table())
        database.db.close_db()
        assert_true(database.add_block(0,0))
        database.db.open_db()
        assert_true(database.db.drop_table(database.FBLOCK_TABLE))
        database.db.close_db()

    func test_init_livestock_table():
        database.db.open_db()
        assert_true(initializer._init_livestock_table())
        database.db.close_db()

        # assert_true(database.add_animal("cow"))

        database.db.open_db()
        assert_true(database.db.drop_table(database.LIVESTOCK_TABLE))
        database.db.close_db()

    func test_init_family_table():
        database.db.open_db()
        assert_true(initializer._init_family_table())
        assert_true(database.db.drop_table(database.FAMILY_TABLE))
        database.db.close_db()

    func test_init_asset_table():
        database.db.open_db()
        assert_true(initializer._init_asset_table())
        database.db.close_db()
        assert_eq(database.add_generic_item("money", database.ASSET_TABLE, 5),1)
        database.db.open_db()
        assert_true(database.db.drop_table(database.ASSET_TABLE))
        database.db.close_db()

    func test_init_upgrades_table():
        database.db.open_db()
        assert_true(initializer._init_upgrades_table())
        assert_true(database.db.drop_table(database.UPGRADE_TABLE))
        database.db.close_db()
