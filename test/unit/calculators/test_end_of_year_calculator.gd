extends GutTest

var eoy_calculator: EOYCalculator
var eoy_controller: EndOfYearController

func before_each():
    eoy_calculator = autofree(partial_double(EOYCalculator).new())
    eoy_controller = autofree(double(EndOfYearController).new())
    # stub(eoy_controller, "_ready").to_do_nothing()
    add_child(eoy_controller)
    gut.p(eoy_controller.get_path())
    eoy_calculator.eoy_controller_path = eoy_controller.get_path()

    watch_signals(eoy_calculator)
    watch_signals(eoy_controller)

# func test__ready():
#     # eoy_calculator.add_child(eoy_controller)
#     add_child(eoy_calculator)
#     assert_called(eoy_calculator, "_ready")
#     assert_connected(eoy_controller, eoy_calculator,"next_year_requested")
#     assert_connected(eoy_calculator, eoy_controller, "summary_completed")

func test__on_next_year_requested():
    eoy_calculator._on_next_year_requested(EventResource.new())
    assert_called(eoy_calculator, "make_summary")
    assert_signal_emitted(eoy_calculator,"summary_completed")

# func test_all():
#     add_child(eoy_calculator)
#     eoy_controller.emit_signal("next_year_requested",EventResource.new())
#     assert_called(eoy_calculator, "make_summary")
#     assert_signal_emitted(eoy_calculator,"summary_completed")


