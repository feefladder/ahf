extends Node

export(NodePath) var income_path
#export(NodePath) var expenses_path

var asset_summary: AssetSummaryResource
var animal_summary: AnimalSummaryResource
var field_summary: FieldSummaryResource

onready var income: IncomeDisplay = get_node(income_path)

func _ready():
    income.make_summary(field_summary, animal_summary, asset_summary)

func _on_NextYearButton_pressed():
    get_tree().get_root().remove_child(self)
    queue_free()
