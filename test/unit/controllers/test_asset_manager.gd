extends GutTest

var asset_controller: AssetController
var db: Database
var popup_insufficient: PopupInsufficient
var popup_max_reached

var chicken = IntResource.new()
var goat = IntResource.new()
var cow = IntResource.new()


func before_all():
    chicken.resource_name = "chicken"
    chicken.unit_price = 10
    chicken.unit_labour = 5
    chicken.max_number = 10

    goat.resource_name = "goat"
    goat.unit_price = 25
    goat.unit_labour = 25
    goat.max_number = 1

    cow.resource_name = "cow"
    cow.unit_price = 150
    cow.unit_labour = 50
    cow.max_number = 2


func before_each():
    asset_controller = partial_double("res://scripts/controllers/asset_controller.gd").new()
    asset_controller.available_money = 100
    asset_controller.available_labour = 100

    popup_insufficient = double("res://scripts/UI/popups/popup_insufficient.gd").new()
    asset_controller.popup_insufficient = popup_insufficient

    popup_max_reached = double("res://scripts/UI/popups/popup_max_reached.gd").new()
    asset_controller.popup_max_reached = popup_max_reached

    db = double(Database).new()
    asset_controller.database = db

    watch_signals(asset_controller)

func test_has_enough():
    assert_true(asset_controller.has_enough(100.0, 100.0))

    assert_false(asset_controller.has_enough(101.0, 100.0))
    assert_called(popup_insufficient, "pop_up_insufficient", [{"money": 1.0}])

    assert_false(asset_controller.has_enough(100.0, 101.0))
    assert_called(popup_insufficient, "pop_up_insufficient", [{"labour": 1.0}])

    assert_false(asset_controller.has_enough(101.0, 101.0))
    assert_called(popup_insufficient, "pop_up_insufficient", [{"money": 1.0, "labour": 1.0}])

func test_buy_item():
    assert_true(asset_controller.buy_item(chicken))
    assert_called(asset_controller, "has_enough", [chicken.unit_price, chicken.unit_labour])
    assert_called(db, "buy_sell_item", [chicken.resource_name, db.BUY_SELL_TABLE, 1])
    assert_eq(asset_controller.used_money, chicken.unit_price)
    assert_eq(asset_controller.used_labour, chicken.unit_labour)
    assert_signal_emitted_with_parameters(asset_controller, "asset_changed", ["money", 90.0], 0)
    assert_signal_emitted_with_parameters(asset_controller, "asset_changed", ["labour", 95.0], 1)

func test_buy_item_insufficient():
    assert_false(asset_controller.buy_item(cow))
    assert_called(asset_controller, "has_enough", [cow.unit_price, cow.unit_labour])
    assert_not_called(db, "buy_sell_item")

func test_sell_item():
    # whether there are any cows to sell is not the asset manager's task
    assert_true(asset_controller.sell_item(cow))
    assert_called(asset_controller, "has_enough", [-cow.unit_price, -cow.unit_labour])
    assert_called(db, "buy_sell_item", [cow.resource_name, db.BUY_SELL_TABLE, -1])
    assert_eq(asset_controller.used_money, -cow.unit_price)
    assert_eq(asset_controller.used_labour, -cow.unit_labour)
    assert_signal_emitted_with_parameters(asset_controller, "asset_changed", ["money", 250.0], 0)
    assert_signal_emitted_with_parameters(asset_controller, "asset_changed", ["labour", 150.0], 1)

func test_start_year():
    stub(db, "get_generic_amount").to_return(50.0).when_passed("money", db.ASSET_TABLE)
    stub(db, "get_generic_amount").to_return(100.0).when_passed("labour", db.ASSET_TABLE)
    asset_controller.start_year()
    assert_called(db, "get_generic_amount")
    assert_eq(asset_controller.available_money, 50.0)
    assert_signal_emitted_with_parameters(asset_controller, "asset_changed", ["money", 50.0], 0)
    assert_signal_emitted_with_parameters(asset_controller, "asset_changed", ["labour", 100.0], 1)