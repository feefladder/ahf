extends Node
class_name EOYCalculator

export(NodePath) var db_path = NodePath("/root/Database")

onready var db: Database = get_node(db_path)

func _ready():
    add_to_group("calculators")

func end_of_year(_event: EventResource) -> void:
    #make calculations and update the database summary table accordingly
    print_debug("non-overriden end_of_year in calculator!", self)
