extends Resource
class_name FertilityResource

export(float, 0, 10) var salinity #dS/m http://dx.doi.org/10.19026/rjees.6.5771 -> 0.3515
export(float, 0, 1) var nutrient_status
export(float, 0, 1) var soil_structure
export(float) var bulk_density = 1233.0 #kg/m3
export(float) var erosion_rate
export(float) var compound_fertility setget _set_compound_fertility, _get_compount_fertility

func _set_compound_fertility(_something: float):
    print("setting compound fertility is not allowed!")

func _get_compount_fertility() -> float:
    return (1-salinity)*nutrient_status*soil_structure

func get_class():
    return "FertilityResource"
