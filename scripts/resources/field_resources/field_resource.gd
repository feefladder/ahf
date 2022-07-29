extends Resource
class_name FertilityResource

export(float, 0, 1) var salinity
export(float, 0, 1) var nutrient_status
export(float, 0, 1) var soil_structure
export(float) var erosion_rate
export(float) var compound_fertility
export(float) var field_block_area = 20.0*20.0/100.0/100.0
export(PackedScene) var field_block_scene
export(int) var size_x = 3
export(int) var size_y = 4
export(Vector2) var dx = Vector2(-58.0,-24.0)
export(Vector2) var dy = Vector2(58, -40)

func calc_compound_fertility():
    return (1-salinity)*nutrient_status*soil_structure
