extends Node
class_name AnnualReview

export(NodePath) var income_path = NodePath("VBoxContainer/Balance/Income")
export(NodePath) var expenses_path = NodePath("VBoxContainer/Balance/Expenses")

var total_income : float
var total_expenses: float

onready var income: IncomeDisplay = get_node(income_path)
onready var expenses = get_node(expenses_path)

func _ready():
    assert( income.connect("income_changed",self,"_on_income_changed") == 0 )
    assert( expenses.connect("expenses_changed",self,"_on_expenses_changed") == 0 )

func _on_NextYearButton_pressed():
    get_tree().get_root().remove_child(self)
    queue_free()

func add_event(event: EventResource):
    if event:
        $VBoxContainer/EventDisplay.display_event(event)

func add_summary(summary):
    if not summary:
        printerr("not sure what you're trying to do with: ", summary)
        return
    if summary is FieldSummaryResource:
        income.add_crop_summary(summary)
        expenses.add_crop_summary(summary)
    elif summary is AssetSummaryResource:
        income.add_asset_summary(summary)
        expenses.add_asset_summary(summary)
    elif summary is SummaryResource:
        printerr("summary making not implemented for ", summary.get_class())
    else:
        printerr("not sure what you're trying to do with: ", summary)

func _on_income_changed(new_amount: float) -> void:
    total_income = new_amount
    $VBoxContainer/CenterContainer/Stat/Amount.text = "%0.2f" % (total_income - total_expenses)

func _on_expenses_changed(new_amount: float) -> void:
    total_expenses = new_amount
    $VBoxContainer/CenterContainer/Stat/Amount.text = "%0.2f" % (total_income - total_expenses)
