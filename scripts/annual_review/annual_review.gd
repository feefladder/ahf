extends Node
class_name AnnualReview

export(NodePath) var income_path = NodePath("VBoxContainer/Balance/Income")
export(NodePath) var expenses_path = NodePath("VBoxContainer/Balance/Expenses")

var income_accounted_for : float
var income_from_review : float
var expenses_accounted_for:float
var expenses_from_review: float

var total_income: float
var total_expenses: float

onready var income: IncomeDisplay = get_node(income_path)
onready var expenses = get_node(expenses_path)
onready var database: Database = get_node("/root/Database")

func _ready():
    get_tree().call_group("annual_review","show_review")
        # node.show_review()

func _on_NextYearButton_pressed():
    database.year += 1
    database.change_generic_item("money", database.ASSET_TABLE, income_from_review-expenses_from_review)
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
