extends Resource
class_name FertilityResource

export(float, 0, 1) var salinity
export(float, 0, 1) var nutrient_status
export(float, 0, 1) var soil_structure
export(float) var erosion_rate
export(float) var compound_fertility
export(float) var field_block_area = 20.0*20.0/100.0/100.0

func calc_compound_fertility():
    return (1-salinity)*nutrient_status*soil_structure
