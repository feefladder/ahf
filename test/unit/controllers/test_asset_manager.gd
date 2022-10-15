extends GutTest

var asset_manager: AssetManager
var popup_insufficient: PopupInsufficient
var popup_max_reached
var chicken = IntResource.new()
var goat = IntResource.new()
var cow = IntResource.new()

func before_all():
    chicken.unit_price = 10
    chicken.unit_labour = 5
    chicken.max_number = 10
 
    goat.unit_price = 25
    goat.unit_labour = 25
    goat.max_number = 1
 
    cow.unit_price = 150
    cow.unit_labour = 50
    cow.max_number = 2


func before_each():
    asset_manager = partial_double("res://scripts/controllers/asset_manager.gd").new()
    asset_manager.money = 100
    asset_manager.labour = 100
 
    popup_insufficient = double("res://scripts/UI/popups/popup_insufficient.gd").new()
    asset_manager.popup_insufficient = popup_insufficient
 
    popup_max_reached = double("res://scripts/UI/popups/popup_max_reached.gd").new()
    asset_manager.popup_max_reached = popup_max_reached
 
    watch_signals(asset_manager)
 
    chicken.current_number = 0
    goat.current_number = 0
    cow.current_number = 0

func test_has_enough():
    assert_true(asset_manager.has_enough(100.0, 100.0))

    assert_false(asset_manager.has_enough(101.0, 100.0))
    assert_called(popup_insufficient, "pop_up_insufficient", [{"money": 1.0}])

    assert_false(asset_manager.has_enough(100.0, 101.0))
    assert_called(popup_insufficient, "pop_up_insufficient", [{"labour": 1.0}])

    assert_false(asset_manager.has_enough(101.0, 101.0))
    assert_called(popup_insufficient, "pop_up_insufficient", [{"money": 1.0, "labour": 1.0}])

func test_decrease_assets():
    assert_true(asset_manager.decrease_assets(100.0, 100.0))
    assert_called(asset_manager, "has_enough", [100.0, 100.0])
    assert_signal_emitted_with_parameters(asset_manager, "asset_changed", ["money", 0.0], 0)
    assert_signal_emitted_with_parameters(asset_manager, "asset_changed", ["labour", 0.0], 1)
    assert_eq(asset_manager.money, 0.0)
    assert_eq(asset_manager.labour, 0.0)

    assert_false(asset_manager.decrease_assets(1.0, 0.0))
    assert_called(asset_manager, "has_enough", [1.0, 0.0])
    assert_eq(asset_manager.money, 0.0)
    assert_eq(asset_manager.labour, 0.0)

    assert_false(asset_manager.decrease_assets(0.0, 1.0))
    assert_called(asset_manager, "has_enough", [0.0, 1.0])
    assert_eq(asset_manager.money, 0.0)
    assert_eq(asset_manager.labour, 0.0)

func test_increase_assets():
    assert_true(asset_manager.increase_assets(100.0, 100.0))
    assert_called(asset_manager, "has_enough", [-100.0, -100.0])
    assert_signal_emitted_with_parameters(asset_manager, "asset_changed", ["money", 200.0], 0)
    assert_signal_emitted_with_parameters(asset_manager, "asset_changed", ["labour", 200.0], 1)
    assert_eq(asset_manager.money, 200.0)
    assert_eq(asset_manager.labour, 200.0)
 
    assert_false(asset_manager.increase_assets(100.0, -205.0))
    assert_called(asset_manager, "has_enough", [-100.0, 205.0])
    assert_eq(asset_manager.money, 200.0)
    assert_eq(asset_manager.labour, 200.0)

func test_try_buy_item_single():
    assert_true(asset_manager.try_buy_item(goat))
    assert_called(asset_manager, "decrease_assets", [goat.unit_price, goat.unit_labour])
    assert_signal_emitted_with_parameters(asset_manager, "asset_changed", [goat, 1])
    assert_eq(goat.current_number, 1)
    assert_has(asset_manager.acquired_assets, goat)
    assert_eq(asset_manager.acquired_assets[goat], 1)
    assert_eq_deep(asset_manager.acquired_assets, {goat: 1})

func test_try_buy_item_max_reached():
    assert_true(asset_manager.try_buy_item(goat))
    assert_eq(goat.current_number, 1)
    assert_eq_deep(asset_manager.acquired_assets, {goat: 1})

    #we can only buy 1 goat
    var signal_count : int = get_signal_emit_count(asset_manager, "asset_changed")
    assert_false(asset_manager.try_buy_item(goat))
    assert_signal_emit_count(asset_manager, "asset_changed", signal_count)
    assert_eq(goat.current_number, 1)
    assert_eq_deep(asset_manager.acquired_assets, {goat: 1})

func test_try_buy_item_too_expensive():
    # the cow is too expensive
    assert_false(asset_manager.try_buy_item(cow))
    assert_does_not_have(asset_manager.acquired_assets, cow)
    assert_eq(cow.current_number, 0)

func test_try_buy_item_multiple():
    assert_true(asset_manager.try_buy_item(chicken))
    assert_true(asset_manager.try_buy_item(chicken))
    assert_eq(chicken.current_number, 2)
    assert_has(asset_manager.acquired_assets, chicken)
    assert_eq(asset_manager.acquired_assets[chicken], 2)

func test_try_buy_item_multiple_types():
    assert_true(asset_manager.try_buy_item(chicken))
    assert_true(asset_manager.try_buy_item(chicken))
    assert_true(asset_manager.try_buy_item(goat))

    assert_eq(chicken.current_number, 2)
    assert_eq(goat.current_number, 1)
    assert_eq_deep(asset_manager.acquired_assets, {
            chicken: 2,
            goat: 1
       })

func test_try_sell_item():
    assert_true(asset_manager.try_buy_item(chicken))
    assert_true(asset_manager.try_sell_item(chicken))
    assert_called(asset_manager, "increase_assets", [chicken.unit_price, chicken.unit_labour])
    assert_eq(asset_manager.money, 100.0)
    assert_eq(asset_manager.labour, 100.0)

    assert_eq(chicken.current_number, 0)
    assert_eq_deep(asset_manager.acquired_assets, {})
    assert_signal_emitted_with_parameters(asset_manager, "asset_changed", [chicken, 0])

func test_try_sell_item_not_have():
    assert_eq(chicken.current_number, 0)
    var signal_count : int = get_signal_emit_count(asset_manager, "asset_changed")
    assert_false(asset_manager.try_sell_item(goat))
    assert_signal_emit_count(asset_manager, "asset_changed", signal_count)

func test_try_sell_item_multiple():
    assert_true(asset_manager.try_buy_item(chicken))
    assert_true(asset_manager.try_buy_item(chicken))
 
    assert_true(asset_manager.try_sell_item(chicken))
    assert_has(asset_manager.acquired_assets, chicken)
    assert_eq_deep(asset_manager.acquired_assets, {chicken : 1})

func test_try_toggle_item():
    var toggle = ToggleResource.new()
    toggle.unit_price = 50
    toggle.unit_labour = -50

 
    assert_true(asset_manager.try_toggle_item(toggle))
    assert_called(asset_manager, "decrease_assets", [toggle.unit_price, toggle.unit_labour])
    assert_signal_emitted_with_parameters(asset_manager, "asset_changed", [toggle, true])
    assert_eq_deep(asset_manager.acquired_assets, {toggle: 1})
 
    assert_true(asset_manager.try_toggle_item(toggle))
    assert_called(asset_manager, "increase_assets", [toggle.unit_price, toggle.unit_labour])
    var num_signals = get_signal_emit_count(asset_manager, "asset_changed")
    assert_signal_emitted_with_parameters(asset_manager, "asset_changed", ["money", 100.0], num_signals - 3)
    assert_signal_emitted_with_parameters(asset_manager, "asset_changed", ["labour", 100.0], num_signals - 2)
    assert_signal_emitted_with_parameters(asset_manager, "asset_changed", [toggle, false], num_signals - 1)
    assert_eq_deep(asset_manager.acquired_assets, {})
