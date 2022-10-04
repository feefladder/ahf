extends GutTest

var end_of_year_calculator: EOYCalculator
var eoy_button: NextYearButton

func before_each():
    end_of_year_calculator = autofree(partial_double(EOYCalculator).new())
    eoy_button = autofree(double(NextYearButton).new())
    stub(eoy_button, "_ready").to_do_nothing()
    add_child(eoy_button)
    gut.p(eoy_button.get_path())
    end_of_year_calculator.eoy_button_path = eoy_button.get_path()

    #not sure why this doesn't work out of the box?
    # assert_true(eoy_button.connect("next_year_requested", end_of_year_calculator, "_on_next_year_requested") == 0)
    # assert_true(end_of_year_calculator.connect("summary_completed", eoy_button, "_on_summary_completed") == 0)

    watch_signals(end_of_year_calculator)
    watch_signals(eoy_button)

func test__ready():
    # end_of_year_calculator.add_child(eoy_button)
    add_child(end_of_year_calculator)
    assert_called(end_of_year_calculator, "_ready")
    
    assert_connected(eoy_button, end_of_year_calculator,"next_year_requested")
    assert_connected(end_of_year_calculator, eoy_button, "summary_completed")

func test__on_next_year_requested():
    end_of_year_calculator._on_next_year_requested(EventResource.new())
    assert_called(end_of_year_calculator, "make_summary")
    assert_signal_emitted(end_of_year_calculator,"summary_completed")

func test_all():
    add_child(end_of_year_calculator)
    eoy_button.emit_signal("next_year_requested",EventResource.new())
    
    assert_called(end_of_year_calculator, "make_summary")
    assert_signal_emitted(end_of_year_calculator,"summary_completed")


