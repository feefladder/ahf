extends Node
class_name AnnualReviewBase

onready var db: Database = get_node_or_null("/root/Database")

func _ready():
    add_to_group("annual_review")

func show_review():
    print_debug("unoverrridden show_review")
