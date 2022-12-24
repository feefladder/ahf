extends Node
class_name AnnualReview

export(NodePath) var income_path = NodePath("VBoxContainer/Balance/Income")
export(NodePath) var expenses_path = NodePath("VBoxContainer/Balance/Expenses")

var total_income : float
var total_expenses: float

onready var income: IncomeDisplay = get_node(income_path)
onready var expenses = get_node(expenses_path)
onready var database: Database = get_node("/root/Database")

func _ready():
    # warning-ignore:return_value_discarded
    income.connect("income_changed",self,"_on_income_changed")
    # warning-ignore:return_value_discarded
    expenses.connect("expenses_changed",self,"_on_expenses_changed")
    get_tree().call_group("annual_review","show_review")

func _on_NextYearButton_pressed():
    database.year += 1
    get_tree().call_group("controllers","start_year")
    get_tree().call_group("displays","start_year")
    get_tree().get_root().remove_child(self)
    queue_free()

func add_event(event: EventResource):
    if event:
        $VBoxContainer/EventDisplay.display_event(event)

func _on_income_changed(new_amount: float) -> void:
    total_income = new_amount
    $VBoxContainer/CenterContainer/Stat/Amount.text = "%0.2f" % (total_income - total_expenses)

func _on_expenses_changed(new_amount: float) -> void:
    total_expenses = new_amount
    $VBoxContainer/CenterContainer/Stat/Amount.text = "%0.2f" % (total_income - total_expenses)
