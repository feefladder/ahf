extends Node
class_name AnnualReviewBase

onready var db: Database = get_node("/root/Database")

func _ready():
    add_to_group("annual_review")

func show_review():
    print_debug("unoverrridden show_review")
