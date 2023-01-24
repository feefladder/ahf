extends GutTest

var yield_calculator: YieldCalculator
var field: Field
var field_resource: FieldResource

# func before_all():
#     #load field resource
#     field_resource = Database.load("res://resources/field/field_data.tres")

# func before_each():
#     yield_calculator = autofree(partial_double(YieldCalculator).new())
#     stub(yield_calculator, "_ready").to_do_nothing()
#     watch_signals(yield_calculator)

#     field = autofree(partial_double(Field).new())
#     field.field_resource = field_resource

#     add_child(field)
#     field.add_child(yield_calculator)


# func test__ready():
#     assert_not_called(yield_calculator, "_ready")
#     add_child(yield_calculator)
#     assert_called(yield_calculator, "_ready")
#     assert_typeof(yield_calculator.summary, CropResource)
#     assert_null(yield_calculator.field) #cannot get parent
#     assert_null(yield_calculator.block_matrix)

func test_calculate_yield():
     pass
