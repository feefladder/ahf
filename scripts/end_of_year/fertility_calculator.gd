extends EOYCalculator

var field: FieldResource
var fertility: FertilityResource
var new_fertility: FertilityResource
#
#func _ready():
#    field = get_parent().field_resource
#    fertility = field.fertility

#func make_summary(_event: EventResource) -> SummaryResource:
#    summary = FieldSummaryResource.new()
#    calc_fertility()
#    return summary

func calc_fertility() -> void:
    new_fertility = FertilityResource.new()
    print(fertility.duplicate(true)) #not supposed to have subresources though
    calc_salinity()
    calc_nutrients()
    calc_soil_structure()
    calc_erosion()
    fertility = new_fertility

func calc_salinity() -> void:
    print("salinity: ", fertility.salinity)

func calc_soil_structure() -> void:
    print("soil structure: ", fertility.soil_structure)

func calc_nutrients() -> void:
    #this determines the slow nutrients, on which artificial fertilizer does not have any
    #effect, but manure, town ash and nitrogen-fixing plants do have an effect
    pass

func calc_erosion() -> void:
    print("erosion rate: ", fertility.erosion_rate)
