extends GutTest

class TestDatabaseUniqueIntItems:
    # class for testing unique int items:
    # livestock
    # add others
    extends GutTest

    var db: Database

    func before_each():
        db = partial_double(Database).new()
        stub(db, "_load_resources").to_return([])
        add_child_autoqfree(db)

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
        stub(db, "_load_resources").to_return([])
        add_child_autoqfree(db)

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
