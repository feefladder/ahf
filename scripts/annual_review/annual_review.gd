extends Node
class_name AnnualReview

export(NodePath) var income_path = NodePath("VBoxContainer/Balance/Income")
export(NodePath) var expenses_path = NodePath("VBoxContainer/Balance/Expenses")

var total_income: float
var total_expenses: float

onready var database: Database = get_node("/root/Database")

func _ready():
	add_to_group("annual_review")
	get_tree().call_group("annual_review","show_review")
		# node.show_review()
	print_debug(total_income-total_expenses)

func _on_NextYearButton_pressed():
	database.year += 1
	# warning-ignore:return_value_discarded
	database.change_generic_item("money", database.ASSET_TABLE, total_income-total_expenses)
	get_tree().call_group("controllers","start_year")
	get_tree().call_group("displays","start_year")
	get_tree().get_root().remove_child(self)
	queue_free()

func add_event(event: EventResource):
	if event:
		$VBoxContainer/EventDisplay.display_event(event)

func add_income(amount: float) -> void:
	total_income += amount
	$Control/CenterContainer/Stat/Amount.text = "%0.2f" % (total_income - total_expenses)
	$Control/Income/VBoxContainer/Total/Amount.text = "%0.2f" % total_income

func add_expense(amount: float) -> void:
	total_expenses += amount
	$Control/CenterContainer/Stat/Amount.text = "%0.2f" % (total_income - total_expenses)
	$Control/Expenses/VBoxContainer/Total/Amount.text = "%0.2f" % total_expenses
