                                            extends EOYCalculator
class_name YieldCalculator

func calculate_yield(b_dict: Dictionary, f_dict: Dictionary, event: YieldEventResource) -> Dictionary:
    var results_dict = {"name":b_dict["crop"]}
    var c_res = b_dict["crop_resource"]
    # theoretical maximum yield (cannot be obtained)
    var final_yield = b_dict["crop_resource"].max_yield
    if not b_dict["irrigation"]:
        # factor due to water stress (in case there is no irrigation)
        # from GYGA
        final_yield *= b_dict["crop_resource"].f_wlimited_yield
    # if there is fertilization, yield is not reduced by nutrients
    if not b_dict["fertilization"]:
        final_yield *= f_dict["nutrient_status"]
    else:
        pass # TODO: nutrient status also has an effect when fertilizers are applied

    final_yield *= f_dict["soil_structure"]
    if f_dict["salinity"] > c_res.ec_threshold:
        # Ya/Ym=1-(EC_e-EC_e,thresh)*b/100 (if b is percentage, FAO 56, eq 89, p 176)
        # this is constant over the growing season, so can be directly determined
        final_yield *= 1-(f_dict["salinity"] - c_res.ec_threshold)*c_res.b
   
    #factor due to other factors (nutrients, pests, etc)
    final_yield *= b_dict["crop_resource"].f_actual_yield

    if event is YieldEventResource:
        final_yield *= (1-event.calc_yield_reduction(b_dict))
    results_dict["yield"] = final_yield
    return results_dict

func end_of_year(event: EventResource) -> void:
    db.db.verbosity_level=2
    # get all blocks
    var crop_b_dicts: Array = db.get_blocks_and_resources("crop IS NOT NULL", ["crop","structural_measure","irrigation","fertilization"])
    var f_dict: Dictionary = db.get_current_fertility(["salinity","nutrient_status","soil_structure","bulk_density","erosion_rate"])[0]
    for b_dict in crop_b_dicts:
        if not db.add_summary(db.CROP_SUM_TABLE, calculate_yield(b_dict, f_dict, event)):
            print_debug("add summary failed")

    db.db.verbosity_level=0
    # get the current year's fertility

#    final_yield *= summary.field.field_block_area
#    print("calculated yield for: ", block, " with value: ", final_yield)
#    summary.add_crop_data(block.crop_resource, final_yield)
