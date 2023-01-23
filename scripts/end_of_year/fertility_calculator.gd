extends EOYCalculator

#func make_summary(_event: EventResource) -> SummaryResource:
#    summary = FieldSummaryResource.new()
#    calc_fertility()
#    return summary

var fblock_dicts: Array 
var fert_dict: Dictionary
var f_erosion_protection := 0.0

func end_of_year(_event) -> void:
    fblock_dicts = db.get_blocks_and_resources("1=1", [
        "crop",
        "structural_measure",
        "measure_improvement",
        "irrigation",
        "fertilization"
    ])
    
    fert_dict = db.get_current_fertility(["salinity","nutrient_status","soil_structure","bulk_density","erosion_rate"])[0]
    fert_dict["salinity"] = calc_salinity()
    fert_dict["nutrient_status"] = calc_nutrients()
    fert_dict["soil_structure"] = calc_soil_structure()
    f_erosion_protection = calc_erosion_protection()
    erode_soil()
    fert_dict["erosion_rate"] = calc_erosion()
    # warning-ignore:return_value_discarded
    db.set_next_dict("FertilityResource", fert_dict)
    # print_debug(fert_dict)

func calc_salinity() -> float:
    print_debug("salinity increase not implemented yet! ", fert_dict["salinity"])
    return fert_dict.get("salinity")

func calc_soil_structure() -> float:
    # print("soil structure: ", fert_dict.get("soil_structure"), fert_dict)
    var soil_structure : float= fert_dict.get("soil_structure")
    var prelim_structure : float = soil_structure
    for fblock_dict in fblock_dicts:
        if fblock_dict.get("fertilization_resource"):
            prelim_structure += fblock_dict["fertilization_resource"].soil_structure_effect
    # print_debug("soil structur: ",soil_structure + prelim_structure/fblock_dicts.size(), fert_dict["soil_structure"])
    return soil_structure + prelim_structure/fblock_dicts.size()

func calc_nutrients() -> float:
    #this determines the slow nutrients, on which artificial fertilizer does not have any
    #effect, but manure, town ash and nitrogen-fixing plants do have an effect
    var prelim_nutrients = fert_dict.get("nutrient_status")
    for fblock_dict in fblock_dicts:
        if fblock_dict.get("fertilization_resource"):
            prelim_nutrients += fblock_dict["fertilization_resource"].long_term_fertilization
        if fblock_dict.get("crop_resource"):
            prelim_nutrients += fblock_dict["crop_resource"].long_term_fertilization
    # print_debug("nutrient_status: ",prelim_nutrients, fert_dict["nutrient_status"])
    return prelim_nutrients

func calc_erosion_protection() -> float:
    var prelim_protection = 0.0
    for fblock_dict in fblock_dicts:
        if fblock_dict.get("structural_measure_resource"):
            prelim_protection += fblock_dict["structural_measure_resource"].erosion_reduction
        if fblock_dict.get("measure_improvement_resource"):
            prelim_protection += fblock_dict["measure_improvement_resource"].erosion_reduction
    # print_debug("erosion protection: ",prelim_protection,"previous: ", f_erosion_protection)
    return prelim_protection/fblock_dicts.size()


func erode_soil() -> void:
    # changes all previous parameters, based on erosion rate
    # actually assum
    # 
    # ----- <- top layer thickness(m) = bdod(kg/m3)/erosion(kg/m2)
    # |###|
    # |###| <- depth of rootzone = 50cm
    # assume some distribution of importance of nutrients etc
    # |###| <-lots of nutrients | not necessarily most, but fastest cycling
    # |~~~|                     |
    # |...| <- no nutrients     \/ exponential gradient
    #  ---> deep percolation?
    # also assume soil structure gradient
    # |###| <-good structure    | not necessarily best, but most important
    # |~~~|                     |
    # |...| <- worse structure  \/ exponential gradient
    var z_r := 0.2
    var z_e:float = fert_dict["erosion_rate"]/fert_dict["bulk_density"]*(1.0 - f_erosion_protection)
    var avg_n:float = fert_dict["nutrient_status"]
    var avg_struct:float = fert_dict["soil_structure"]
    # format in LaTeX
    # assuming linear:
    # \rho_n = (2*avg-z*2*avg/z_r)/z_r
    # \int_0^{z_r}\rho_n = [2*avg*z-z^2*avg/z_r]_0^{z_r}/z_r
    # = (2*avg*z_r-z_r^2*avg/z_r)/z_r = avg
    # \int_{0}^{z_e}\rho_n = [2*avg*z-z^2*avg.z_r]_0^{z_e}/z_r
    # = 2*avg*z_e/z_r-z_e^2*avg/z_r^2
    
    # fert_dict["nutrient_status"] = 2*avg_n*z_e/z_r-pow(z_e,2)*avg_n/pow(z_r,2)
    # fert_dict["soil_structure"] = 2*avg_struct*z_e/z_r-pow(z_e,2)*avg_struct/pow(z_r,2)
    
    # assuming exponential:
    # \int_0^{z_r} a*\exp(z)= avg
    # (\exp(z_r)-1)a = avg
    # a = \frac{avg}{\exp(z_r)-1}
    # \rho_n = \exp(z)*\frac{avg}{\exp(z_r)-1}
    # \int_0^z_e\rho_n = (\exp(z_e)-1)\frac{avg}{\exp(z_r)-1}
    var frac_lost: float = (exp(z_e)-1)/(exp(z_r)-1)
    fert_dict["nutrient_status"] *= avg_n*(1.0-frac_lost)
    fert_dict["soil_structure"] *= avg_struct*(1.0-frac_lost)

    print_debug("erosion rate: ", fert_dict.erosion_rate, " z_e: ",z_e," frac_lost: ", frac_lost)

func calc_erosion() -> float:
    var prelim_erosion: float = fert_dict["erosion_rate"]
    print_debug("base erosion rate does not change!")
    return prelim_erosion#*(1.0-f_erosion_protection)
