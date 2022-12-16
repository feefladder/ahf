extends EOYCalculator
class_name YieldCalculator

func calculate_yield(block: FieldBlock, event: YieldEventResource) -> void:
    if not block.has_crop:
        return

    # theoretical maximum yield (cannot be obtained)
    var final_yield = block.crop_resource.max_yield
    if not block.has_irrigation:
        #factor due to water stress (in case there is no irrigation)
        final_yield *= block.crop_resource.f_wlimited_yield
    #factor due to other factors (nutrients, pests, etc)
    final_yield *= block.crop_resource.f_actual_yield

    if event:
        final_yield *= (1-event.calc_yield_reduction(block))

#    final_yield *= summary.field.field_block_area
#    print("calculated yield for: ", block, " with value: ", final_yield)
#    summary.add_crop_data(block.crop_resource, final_yield)
