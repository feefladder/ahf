extends Resource
class_name FieldResource

export(Resource) var fertility #make this FertilityResource in Godot4.0
export(float) var field_block_area = 20.0*20.0/100.0/100.0
export(PackedScene) var field_block_scene
export(int) var size_x = 3
export(int) var size_y = 4
export(Vector2) var dx = Vector2(-58.0,-24.0)
export(Vector2) var dy = Vector2(58, -40)

func get_class():
    return "FieldResource"
