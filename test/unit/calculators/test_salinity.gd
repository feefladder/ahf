
extends GutTest
func test_salinity():
    var soil_salinity = 0.5
    var leaching_factor = 0.901
    var irrigation_ec = 0.352

    var irrigation_amount = 1000
    var precipitation_amount = 500
    var evaporation_rate = 0.5

    var net_water_balance = 0
    var net_soil_salinity_change = 0

    var irrigation_events_per_year = 365 / 3

    var shc = 0.1

    for i in range(1, 6):
        net_water_balance = irrigation_amount * irrigation_events_per_year + precipitation_amount - evaporation_rate
        
        net_soil_salinity_change = (irrigation_ec * leaching_factor) / (net_water_balance * shc)
        
        soil_salinity += net_soil_salinity_change
        
        print("Soil salinity after year " + str(i) + ": " + str(soil_salinity))
