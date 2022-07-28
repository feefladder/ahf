extends Node

export(PackedScene) var end_of_year_packedscene = preload("res://scenes/annual_review/annual_review.tscn")
export(PackedScene) var end_of_game_packedscene = preload("res://scenes/end_of_game.tscn")
export(NodePath) var field_path
export(NodePath) var animals_path
export(NodePath) var asset_manager_path
export(NodePath) var years_stat_path = "../YearsStat"
export(int) var current_year = 1
export(int) var max_years = 20

onready var field: Field = get_node(field_path)
onready var animals: Animals = get_node(animals_path)
onready var asset_manager: AssetManager = get_node(asset_manager_path)
onready var years_stat = get_node(years_stat_path)

func _on_NextYearButton_pressed():
    var end_of_year_scene = end_of_year_packedscene.instance()
    end_of_year_scene.field_summary = field.make_summary()
    end_of_year_scene.animal_summary = animals.make_summary()
    end_of_year_scene.asset_summary = asset_manager.make_summary()

    current_year += 1
    years_stat._on_stat_changed(current_year)

    if current_year == max_years:
        get_tree().get_root().add_child(end_of_game_packedscene.instance())
    else:
        get_tree().get_root().add_child(end_of_year_scene)
