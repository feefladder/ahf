extends Node
class_name NextYearButton

signal next_year_requested(event)

export(PackedScene) var annual_review_packedscene = preload("res://scenes/annual_review/annual_review.tscn")
export(PackedScene) var end_of_game_packedscene = preload("res://scenes/end_of_game.tscn")
export(NodePath) var years_stat_path = NodePath("../YearsStat")
export(NodePath) var database_path = NodePath("/root/Database")

var annual_review: AnnualReview

export(int) var current_year := 1
export(int) var max_years := 20

var years_stat: Stat
var database: Database

func _ready():
    years_stat = get_node(years_stat_path)
    
    database = get_node(database_path)

func _on_NextYearButton_pressed():
    current_year += 1
    years_stat._on_stat_changed("year", current_year)

    if current_year == max_years:
        get_tree().get_root().add_child(end_of_game_packedscene.instance())
    else:
        annual_review = annual_review_packedscene.instance()
        get_tree().get_root().add_child(annual_review)
        var event: EventResource = $EventManager.get_event()
        annual_review.add_event(event)
        emit_signal("next_year_requested", event)

func _on_summary_completed(summary):
    if summary:
        annual_review.add_summary(summary)
    else:
        printerr("No summary received")
